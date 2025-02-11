//
//  UploadVM.swift
//  WeClimb
//
//  Created by 강유정 on 2/3/25.
//

import RxRelay
import PhotosUI
//// 업로드용
//struct PostUploadData {
//    let user: User
//    let gym: String?
//    let caption: String?
//    let medias: [MediaUploadData]
//}
//
//struct MediaUploadData {
//    let url: URL
//    let hold: String?
//    let grade: String?
//    let thumbnailURL: URL?
//}
import RxSwift
import RxRelay
import PhotosUI

protocol UploadVMProtocol {
    func transform(input: UploadVM.Input) -> UploadVM.Output
}

final class UploadVM: UploadVMProtocol {
    
    struct Input {
        let mediaSelection: Observable<[PHPickerResult]>
        let gradeSelection: Observable<(Int, String)>
        let holdSelection: Observable<(Int, String?)>
        let selectedMediaIndex: Observable<Int>
    }
    
    struct Output {
        let mediaItems: Observable<[MediaUploadData]>
    }
    
    private let disposeBag = DisposeBag()
    
    private let mediaItemsRelay = BehaviorRelay<[PHPickerResult]>(value: [])
    var mediaUploadDataRelay = BehaviorRelay<[MediaUploadData]>(value: [])
        
        func transform(input: Input) -> Output {
            
            input.mediaSelection
                .subscribe(onNext: { [weak self] mediaItems in
                    self?.mediaItemsRelay.accept(mediaItems)
                    self?.processMediaItems(mediaItems: mediaItems)
                })
                .disposed(by: disposeBag)
            
            input.gradeSelection
                .subscribe(onNext: { [weak self] (index, newGrade) in
                    guard let self = self else { return }
                    
                    var mediaList = self.mediaUploadDataRelay.value
                    guard index >= 0, index < mediaList.count else { return }

                    if mediaList[index].grade == newGrade { return }

                    var updatedMedia = mediaList[index]
                    updatedMedia.grade = newGrade
                    mediaList[index] = updatedMedia

                    self.mediaUploadDataRelay.accept(mediaList)
                })
                .disposed(by: disposeBag)

            input.holdSelection
                .subscribe(onNext: { [weak self] (index, newHold) in
                    guard let self = self else { return }
                    
                    var mediaList = self.mediaUploadDataRelay.value
                    guard index >= 0, index < mediaList.count else { return }

                    if mediaList[index].hold == newHold { return }
                    
                    var updatedMedia = mediaList[index]
                    updatedMedia.hold = newHold
                    mediaList[index] = updatedMedia

                    self.mediaUploadDataRelay.accept(mediaList)
                })
                .disposed(by: disposeBag)

            return Output(
                mediaItems: mediaUploadDataRelay.asObservable()
            )
        }

    private func processMediaItems(mediaItems: [PHPickerResult]) {
        let group = DispatchGroup()
        var models = [MediaUploadData?](repeating: nil, count: mediaItems.count)
        
        mediaItems.enumerated().forEach { index, mediaItem in
            group.enter()
            
            if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                mediaItem.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] (url, error) in
                    guard let self = self, let url = url, error == nil else {
                        print("비디오 파일 로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                        group.leave()
                        return
                    }
                    
                    let tempVideoURL = FileManager.default.temporaryDirectory
                        .appendingPathComponent(UUID().uuidString)
                        .appendingPathExtension("mp4")
                    
                    do {
                        try FileManager.default.copyItem(at: url, to: tempVideoURL)
                        print("비디오 파일이 임시 디렉토리에 저장됨: \(tempVideoURL.path)")
                    } catch {
                        print("비디오 파일 복사 실패: \(error.localizedDescription)")
                        group.leave()
                        return
                    }
                    
                    let asset = AVAsset(url: tempVideoURL)
                    guard asset.isPlayable else {
                        print("비디오 파일이 재생 불가능 상태입니다.")
                        group.leave()
                        return
                    }
                    
                    models[index] = MediaUploadData(
                        url: tempVideoURL,
                        hold: nil,
                        grade: "",
                        thumbnailURL: tempVideoURL
                    )
                    group.leave()
                }
            } else if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                mediaItem.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let uiImage = image as? UIImage else {
                        print("🚨 이미지 로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                        group.leave()
                        return
                    }
                    
                    let tempImageURL = FileManager.default.temporaryDirectory
                        .appendingPathComponent(UUID().uuidString)
                        .appendingPathExtension("jpg")
                    
                    if let data = uiImage.jpegData(compressionQuality: 1) {
                        do {
                            try data.write(to: tempImageURL)
                            
                            models[index] = MediaUploadData(
                                url: tempImageURL,
                                hold: nil,
                                grade: "",
                                thumbnailURL: tempImageURL
                            )
                        } catch {
                            print("이미지 저장 실패: \(error.localizedDescription)")
                        }
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let validModels = models.compactMap { $0 }
            self.mediaUploadDataRelay.accept(validModels)
        }
    }
}
