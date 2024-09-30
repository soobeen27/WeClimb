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
        isLoading.accept(true) // 로딩 시작
        
        let group = DispatchGroup() // 비동기 작업을 추적하기 위한 그룹
        var models = [FeedCellModel?](repeating: nil, count: mediaItems.value.count)
        
        mediaItems.value.enumerated().forEach { (index, mediaItem) in
            group.enter()   // 비동기 작업 시작 알려줌
            
            if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                mediaItem.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] (url, error) in
                    guard let self = self, let url = url, error == nil else {
                        print("비디오 파일 로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                        group.leave()
                        return
                    }
                    
                    // 임시 디렉토리로 파일 복사
                    let tempVideoURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
                    do {
                        try FileManager.default.copyItem(at: url, to: tempVideoURL)
                        print("비디오 파일이 임시 디렉토리에 저장됨: \(tempVideoURL.path)")
                        } catch {
                            print("비디오 파일 복사 실패: \(error.localizedDescription)")
                            group.leave()
                            return
                        }
                        
                        // AVAsset으로 비디오 상태 확인
                        let asset = AVAsset(url: tempVideoURL)
                        let isPlayable = asset.isPlayable
                        let hasProtectedContent = asset.hasProtectedContent
                        print("비디오 파일 상태: isPlayable=\(isPlayable), hasProtectedContent=\(hasProtectedContent)")
                        
                        // 파일이 재생 가능한 상태인지 확인
                        guard isPlayable else {
                            print("비디오 파일이 재생 불가능 상태입니다.")
                            group.leave()
                            return
                        }
                        
                        // 최종적으로 비디오 파일 로드
                        Task {
                            let durationInSeconds = await self.checkVideoDuration(url: tempVideoURL)
                            if durationInSeconds > 60 {
                                self.showAlert.accept(())
                                print("비디오가 너무 깁니다. 알람을 보냅니다.")
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
        
        // 비동기 작업이 모두 완료되었을 때 호출되는 클로저
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.isLoading.accept(false) // 로딩 종료
            
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
            // duration 속성을 await으로 로드
            let duration: CMTime = try await asset.load(.duration)
            // CMTime 객체를 초 단위로 변환
            let durationInSeconds = CMTimeGetSeconds(duration)
            print("비디오 길이: \(durationInSeconds)초")
            return durationInSeconds
        } catch {
            print("비디오 길이 로드 실패: \(error.localizedDescription)")
            return 0 // 실패 시 0초 반환
        }
    }
}

extension UploadVM {
    func upload(media: [(url: URL, sector: String?, grade: String?)], caption: String?, gym: String?, thumbnailURL: String) -> Observable<Void> {
        return Observable.create { observer in
            let dispatchGroup = DispatchGroup()
            var uploadMedia: [(url: URL, sector: String?, grade: String?)] = []
            
            for item in media {
                dispatchGroup.enter()
                
                // 이미지인 경우
                if item.url.pathExtension == "jpg" || item.url.pathExtension == "png" {
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
                Task { [uploadMedia, caption, gym] in
                    await FirebaseManager.shared.uploadPost(media: uploadMedia, caption: caption, gym: gym, thumbnail: thumbnailURL)
                    observer.onNext(())
                    observer.onCompleted()
                }
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
    
  func getThumbnailImage(from videoURL: URL, completion: @escaping (String?) -> Void) {
        print("썸네일 이미지 생성중")
        
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        let time = CMTime(seconds: 1, preferredTimescale: 600) // 1초에서 썸네일 생성
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero
        imageGenerator.appliesPreferredTrackTransform = true // 방향
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, image, _, result, error in
            if let error = error {
                print("썸네일 생성 중 오류 발생: \(error.localizedDescription)")
                completion(nil)
            } else if let image = image {
                print("썸네일이 성공적으로 생성.")
                let uiImage = UIImage(cgImage: image)
                
                // 이미지를 URL로 변환
                if let thumbnailData = uiImage.jpegData(compressionQuality: 0.8) {
                    let tempDirectory = FileManager.default.temporaryDirectory
                    let thumbnailURL = tempDirectory.appendingPathComponent("\(UUID().uuidString).jpg")
                    
                    do {
                        try thumbnailData.write(to: thumbnailURL)
                        completion(thumbnailURL.absoluteString)
                    } catch {
                        print("썸네일 저장 실패: \(error.localizedDescription)")
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            } else {
                print("생성된 이미지가 없음.")
                completion(nil)
            }
        }
    }
}
