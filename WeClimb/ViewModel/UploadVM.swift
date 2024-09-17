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
                    guard let self = self, let url = url, error == nil else { return }
                    
                    mediaItem.itemProvider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { [weak self] (item, error) in
                        guard let self else { return }
                        if let videoURL = item as? URL {
                            print("\(videoURL)")
//                            self.printVideoFileSize(url: videoURL) // 원본 비디오 파일 크기 출력
                            
                            self.checkVideoDuration(url: videoURL) { durationInSeconds in
                                if durationInSeconds > 60 {
                                    self.showAlert.accept(())
                                    print("알람 알럿 이벤트 방출")
                                    group.leave()
                                    return
                                    
                                } else {
//
//                                    self.compressVideo(inputURL: videoURL) {compressedURL in
//                                        guard let compressedURL = compressedURL else {
//                                            print("비디오 압축 오류.")
//                                            group.leave()   // 비동기 작업이 끝난걸 알려줌
//                                            return
//                                        }
//                                        self.printVideoFileSize(url: compressedURL) // 압축 후 비디오 파일 크기 출력
                                        let newItem = FeedCellModel(image: nil, videoURL: videoURL)
                                    models[index] = newItem
                                    group.leave()
//                                    }
                                }
                            }
                        }
                    }
                }
            } else if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                mediaItem.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    let newItem = FeedCellModel(image: image as? UIImage, videoURL: nil)
                    models[index] = newItem
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
            }
        }
    }
}

extension UploadVM {
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

extension UploadVM {
    // MARK: - 비디오 길이를 체크하는 메서드
    func checkVideoDuration(url: URL, completion: @escaping (Double) -> Void) {
        let asset = AVAsset(url: url)
        
        Task {
            do {
                // duration 속성을 비동기적으로 로드
                try await asset.load(.duration)
                
                // CMTime 객체를 초 단위로 변환
                let duration = asset.duration
                let durationInSeconds = CMTimeGetSeconds(duration)
                print("비디오 길이: \(durationInSeconds)초")
                
                completion(durationInSeconds)
            } catch {
                print("비디오 길이 로드 실패: \(error.localizedDescription)")
                completion(0) // 실패 시 0초 반환
            }
        }
    }
}
