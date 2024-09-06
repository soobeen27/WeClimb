//
//  FeedViewModel.swift
//  WeClimb
//
//  Created by 강유정 on 9/6/24.
//

import AVKit
import PhotosUI

import RxRelay
import RxSwift

class FeedViewModel {
    let mediaItems: [PHPickerResult]    // 사용자가 선택한 미디어 항목의 배열
    let feedRelay = BehaviorRelay(value: [FeedCellModel]())
    
    init(mediaItems: [PHPickerResult]) {
        self.mediaItems = mediaItems
        self.process()
    }
}

extension FeedViewModel {
    // MARK: - 미디어 항목을 처리하는 메서드 YJ
    func process() {
        let group = DispatchGroup() // 비동기 작업을 추적하기 위한 그룹
        var models = [FeedCellModel]()
        
        mediaItems.forEach { mediaItem in
            group.enter()   // 비동기 작업 시작 알려줌
            
            if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                mediaItem.itemProvider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { [weak self] (item, error) in
                    guard let self else { return }
                    if let videoURL = item as? URL {
                        print("\(videoURL)")

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
            self.feedRelay.accept(models)
        }
    }
}

extension FeedViewModel {
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
