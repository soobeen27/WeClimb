//
//  UploadVM.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import AVKit
import PhotosUI

import RxRelay
import RxSwift

class UploadVM {
    let mediaItems = BehaviorRelay<[PHPickerResult]>(value: [])
    let feedRelay = BehaviorRelay(value: [FeedCellModel]())
    let showAlert = PublishRelay<Void>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    init(mediaItems: [PHPickerResult]) {
        self.mediaItems.accept(mediaItems) // BehaviorRelay의 값을 업데이트
        self.setMedia()
    }
    
    func optionSelected(optionText: String) {
        print("선택된 옵션: \(optionText)")
    }
}

extension UploadVM {
    // MARK: - 미디어 항목을 처리하는 메서드 YJ
    func setMedia() {
        isLoading.accept(true) // 로딩 시작
        
        let group = DispatchGroup() // 비동기 작업을 추적하기 위한 그룹
        var models = [FeedCellModel]()
        
        mediaItems.value.forEach { mediaItem in
            group.enter()   // 비동기 작업 시작 알려줌
            
            if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                mediaItem.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] (url, error) in
                    guard let self = self, let url = url, error == nil else { return }
                    
                    mediaItem.itemProvider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { [weak self] (item, error) in
                        guard let self else { return }
                        if let videoURL = item as? URL {
                            print("\(videoURL)")
                            
                            self.checkVideoDuration(url: videoURL) { durationInSeconds in
                                if durationInSeconds > 60 {
                                    self.showAlert.accept(())
                                    print("알람 알럿 이벤트 방출")
                                    group.leave()
                                    return
                                    
                                } else {
                                    
                                    self.compressVideoTo720p(url: videoURL) {compressedURL in
                                        guard let compressedURL = compressedURL else {
                                            print("비디오 압축 오류.")
                                            group.leave()   // 비동기 작업이 끝난걸 알려줌
                                            return
                                        }
                                        let newItem = FeedCellModel(image: nil, videoURL: compressedURL)
                                        models.append(newItem)
                                        group.leave()
                                    }
                                }
                            }
                        }
                    }
                }
            } else if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                mediaItem.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    let newItem = FeedCellModel(image: image as? UIImage, videoURL: nil)
                    models.append(newItem)
                    group.leave()
                }
            }
        }
        
        // 비동기 작업이 모두 완료되었을 때 호출되는 클로저
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.isLoading.accept(false) // 로딩 종료
            self.feedRelay.accept(models)
        }
    }
}

extension UploadVM {
    // MARK: - 비디오를 압축하는 메서드 YJ
    func compressVideoTo720p(url: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: url)
        let presetName = AVAssetExportPresetMediumQuality // 720p에 가까운 중간 품질 프리셋
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: presetName) else {
            print("압축 세션 생성 오류.")
            completion(nil)
            return
        }
        
        // 압축된 비디오 파일을 저장할 URL 생성
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
        
        exportSession.outputURL = outputURL // 출력 URL 설정
        exportSession.outputFileType = .mp4 // 파일 형식 설정
        exportSession.shouldOptimizeForNetworkUse = true    // 네트워크 사용 최적화
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("비디오 압축 완료: \(outputURL)")
                completion(outputURL)
            case .failed, .cancelled:
                print("비디오 압축 실패: \(exportSession.error?.localizedDescription ?? "알 수 없는 오류")")
                completion(nil)
            default:
                print("비디오 압축 상태: \(exportSession.status.rawValue)")
                completion(nil)
            }
        }
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
