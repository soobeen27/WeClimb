//
//  UploadVM.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import AVKit
import PhotosUI

import LightCompressor
import RxRelay
import RxSwift

class UploadVM {
    let mediaItems = BehaviorRelay<[PHPickerResult]>(value: [])
    let feedRelay = BehaviorRelay(value: [FeedCellModel]())
    let cellData = BehaviorRelay(value: [FeedCellModel]())
    
    let showAlert = PublishRelay<Void>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    // 피커뷰에서 선택한 항목을 저장
    var selectedFeedItems = [FeedCellModel]()
    
    let pageChanged = PublishRelay<Int>()
    private var currentPageIndex = 0
    
    var shouldUpdateUI: Bool = true
}

extension UploadVM {
    // MARK: - 각 미디어마다 선택한 옵션 저장 YJ
    func optionSelected(optionText: String, buttonType: String) {
        print("옵션 선택됨: \(optionText), 현재 페이지 인덱스: \(currentPageIndex)")
        
        var currentFeedItems = feedRelay.value
        var feedItem = currentFeedItems[currentPageIndex]
        print("currentFeedItems: \(currentFeedItems)")

        if buttonType == "grade" {
            feedItem.grade = optionText
        } else if buttonType == "sector" {
            feedItem.sector = optionText
        }

        currentFeedItems[currentPageIndex] = feedItem
        shouldUpdateUI = false  // UI업데이트 X
        feedRelay.accept(currentFeedItems)
    }
    
    // MARK: - 페이지 변경 이벤트 방출 YJ
    func pageChanged(to pageIndex: Int) {
        pageChanged.accept(pageIndex)
    
        currentPageIndex = pageIndex
    }
    
    // MARK: - 선택한 암장 정보 저장 YJ
    func optionSelectedGym(_ gymInfo: Gym) {
        let gymName = gymInfo.gymName
        
        var feedItem = feedRelay.value
        
        // feedRelay의 모든 항목의 gym 속성을 업데이트
        for index in feedItem.indices {
            feedItem[index].gym = gymName
        }
        shouldUpdateUI = false
        feedRelay.accept(feedItem)
        print("feedRelay/gym: \(feedRelay)")
    }
}

extension UploadVM {
    // MARK: - 미디어 항목을 처리하는 메서드 YJ
    func setMedia() {
        isLoading.accept(true)
        
        let group = DispatchGroup()
        var models = [FeedCellModel?](repeating: nil, count: mediaItems.value.count)
        
        mediaItems.value.enumerated().forEach { (index, mediaItem) in
            group.enter()

            if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                mediaItem.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] (url, error) in
                    guard let self = self, let url = url, error == nil else {
                        print("비디오 파일 로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                        group.leave()
                        return
                    }

                    let tempVideoURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
                    do {
                        try FileManager.default.copyItem(at: url, to: tempVideoURL)
                        print("비디오 파일을 임시 디렉토리에 저장: \(tempVideoURL.path)")
                    } catch {
                        print("비디오 파일 복사 실패: \(error.localizedDescription)")
                        group.leave()
                        return
                    }

                    // 비디오 상태 확인
                    Task {
                        let asset = AVAsset(url: tempVideoURL)
                        let isPlayable = try await asset.load(.isPlayable)
                        let hasProtectedContent = try await asset.load(.hasProtectedContent)
                        print("비디오 파일 상태: isPlayable=\(isPlayable), hasProtectedContent=\(hasProtectedContent)")

                        guard isPlayable else {
                            print("비디오 파일이 재생 불가능 상태.")
                            group.leave()
                            return
                        }

                        let durationInSeconds = await self.checkVideoDuration(url: tempVideoURL)
                        if durationInSeconds > 60 {
                            self.showAlert.accept(())
                            print("비디오가 1분 이상")
                        } else {
                            models[index] = FeedCellModel(imageURL: nil, videoURL: tempVideoURL)
                        }
                        group.leave()
                    }
                }
            } else if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                mediaItem.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let uiImage = image as? UIImage else {
                        print("이미지 로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                        group.leave()
                        return
                    }

                    // 임시 디렉토리에 이미지 저장
                    let tempImageURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")

                    if let data = uiImage.jpegData(compressionQuality: 1) {
                        do {
                            try data.write(to: tempImageURL)
                            models[index] = FeedCellModel(imageURL: tempImageURL, videoURL: nil)
                        } catch {
                            print("이미지 저장 실패: \(error.localizedDescription)")
                        }
                    }
                    group.leave()
                }
            }
        }
    
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.isLoading.accept(false)

            if !models.isEmpty {
                self.feedRelay.accept(models.compactMap { $0 })
                self.cellData.accept(models.compactMap { $0 })
            }
        }
    }
}

extension UploadVM {
    // MARK: - 비디오 길이를 체크하는 메서드
    func checkVideoDuration(url: URL) async -> Double {
        print("비디오 URL: \(url)")
        let asset = AVAsset(url: url)
        
        do {
            // 비디오 트랙 로드
            let tracks = try await asset.loadTracks(withMediaType: .video)
            if tracks.isEmpty {
                print("지원되지 않는 비디오 형식입니다. 비디오 트랙이 없습니다.")
                return 0
            }
            
            // 비디오 길이 확인
            let duration: CMTime = try await asset.load(.duration)  // duration 속성을 await으로 로드
            let durationInSeconds = CMTimeGetSeconds(duration)  // CMTime 객체를 초 단위로 변환
            print("비디오 길이: \(durationInSeconds)초")
            return durationInSeconds
        } catch {
            print("비디오 길이 로드 실패: \(error.localizedDescription)")
            return 0 // 실패 시 0초 반환
        }
    }
}

extension UploadVM {
    func upload(media: [(url: URL, sector: String?, grade: String?)], caption: String?, gym: String?) -> Observable<Void> {
        return Observable.create { observer in
            let dispatchGroup = DispatchGroup()
            var uploadMedia: [(url: URL, sector: String?, grade: String?)] = []
            
            for item in media {
                dispatchGroup.enter()
                
                // 이미지인 경우
                if item.url.pathExtension == "jpg" {
                    uploadMedia.append((url: item.url, sector: item.sector, grade: item.grade)) // 압축 X
                    dispatchGroup.leave()
                } else {
                    // 비디오인 경우
                    self.compressVideo(inputURL: item.url) { compressedURL in
                        if let compressedURL = compressedURL {
                            uploadMedia.append((url: compressedURL, sector: item.sector, grade: item.grade))
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                FirebaseManager.shared.uploadPost(media: uploadMedia, caption: caption, gym: gym)
                observer.onNext(())
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - 비디오를 압축하는 메서드
    func compressVideo(inputURL: URL, completion: @escaping (URL?) -> Void) {
        let videoCompressor = LightCompressor()
        
        // 압축 작업 설정
        _ = videoCompressor.compressVideo(videos: [
            .init(
                source: inputURL,
                destination: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4"),
                configuration: .init(
                    quality: VideoQuality.very_high, // 비디오 품질
                    videoBitrateInMbps: 2, // 비트레이트
                    disableAudio: false, // 오디오
                    keepOriginalResolution: false, // 원본 해상도 변경
                    videoSize: nil
                )
            )
        ],
        progressQueue: .main,
        progressHandler: { progress in
            DispatchQueue.main.async { [unowned self] in
                // Handle progress- "\(String(format: "%.0f", progress.fractionCompleted * 100))%"
            }},
                                                        
            completion: {[weak self] result in
            guard self != nil else { return }
            
            switch result {
                
            case .onSuccess(_, let path):
                print("비디오 압축 완료: \(path)")
                completion(path)
            case .onStart:
                print("압축 시작")
            case .onFailure(_, let error):
                print("비디오 압축 실패: \(error.localizedDescription)")
                completion(nil)
            case .onCancelled:
                print("비디오 압축 취소됨")
                completion(nil)
            }
        })
        // compression.cancel = true
    }
}
