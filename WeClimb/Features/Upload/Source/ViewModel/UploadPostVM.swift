//
//  UploadPostVM.swift
//  WeClimb
//
//  Created by 강유정 on 2/11/25.
//

import RxSwift
import RxCocoa
import UIKit
import LightCompressor

protocol UploadPostInput {
    var submitButtonTap: Observable<Void> { get }
    var captionText: Observable<String> { get }
    var gymName: String { get }
    var mediaItems: [MediaUploadData] { get }
}

protocol UploadPostOutput {
    var uploadResult: Observable<Void> { get }
}

protocol UploadPostVM {
    func transform(input: UploadPostInput) -> UploadPostOutput
}

class UploadPostVMImpl: UploadPostVM {
    struct Input: UploadPostInput {
        let submitButtonTap: Observable<Void>
        let captionText: Observable<String>
        let gymName: String
        let mediaItems: [MediaUploadData]
    }
    
    struct Output: UploadPostOutput {
        let uploadResult: Observable<Void>
    }
    
    private let disposeBag = DisposeBag()
    private let uploadPostUseCase: UploadPostUseCase
    private let myUserInfoUseCase: MyUserInfoUseCase
    
    private let isSubmitPendingRelay = BehaviorRelay<Bool>(value: false)
    private let isCompressionCompleteRelay = BehaviorRelay<Bool>(value: false)
    private let compressedMediaRelay = BehaviorRelay<[URL]?>(value: nil)
    private let latestCaptionRelay = BehaviorRelay<String>(value: "")
    
    init(uploadPostUseCase: UploadPostUseCase, myUserInfoUseCase: MyUserInfoUseCase) {
        self.uploadPostUseCase = uploadPostUseCase
        self.myUserInfoUseCase = myUserInfoUseCase
    }
    
    func transform(input: UploadPostInput) -> UploadPostOutput {
        let uploadSuccess = PublishRelay<Void>()

        input.submitButtonTap
            .withLatestFrom(input.captionText)
            .subscribe(onNext: { latestCaption in
                self.latestCaptionRelay.accept(latestCaption)
                self.isSubmitPendingRelay.accept(true)

                if self.isCompressionCompleteRelay.value, let compressedMedia = self.compressedMediaRelay.value {
                    self.startUpload(caption: latestCaption, compressedMediaURLs: compressedMedia, input: input, uploadSuccess: uploadSuccess)
                }
            })
            .disposed(by: disposeBag)

        input.captionText
            .bind(to: latestCaptionRelay)
            .disposed(by: disposeBag)

        compressMediaItems(input.mediaItems)
            .subscribe(onNext: { compressedMediaURLs in
                self.compressedMediaRelay.accept(compressedMediaURLs)
                self.isCompressionCompleteRelay.accept(true)
            })
            .disposed(by: disposeBag)

        isCompressionCompleteRelay
            .filter { $0 }
            .subscribe(onNext: { _ in
                if self.isSubmitPendingRelay.value, let compressedMedia = self.compressedMediaRelay.value {
                    let latestCaption = self.latestCaptionRelay.value
                    self.startUpload(caption: latestCaption, compressedMediaURLs: compressedMedia, input: input, uploadSuccess: uploadSuccess)
                }
            })
            .disposed(by: disposeBag)

        return Output(uploadResult: uploadSuccess.asObservable())
    }

    private func startUpload(caption: String, compressedMediaURLs: [URL], input: UploadPostInput, uploadSuccess: PublishRelay<Void>) {
        let updatedMediaItems: [MediaUploadData] = zip(input.mediaItems, compressedMediaURLs).map { original, compressedURL in
            MediaUploadData(
                url: compressedURL,
                hold: original.hold,
                grade: original.grade,
                thumbnailURL: original.thumbnailURL,
                capturedDate: original.capturedDate
            )
        }

        uploadPost(caption: caption, mediaItems: updatedMediaItems, gymName: input.gymName)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    uploadSuccess.accept(())
                case .failure(let error):
                    print("업로드 실패: \(error.localizedDescription)")
                }

                self.isSubmitPendingRelay.accept(false)
                self.isCompressionCompleteRelay.accept(false)
                self.compressedMediaRelay.accept(nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func compressMediaItems(_ mediaItems: [MediaUploadData]) -> Observable<[URL]> {
        let totalCount = mediaItems.count
        var completedCount = 0

        return Observable.from(mediaItems.enumerated())
            .flatMap { (index, media) -> Observable<(Int, URL)> in
                return Observable.create { observer in
                    let onComplete: (URL) -> Void = { compressedURL in
                        observer.onNext((index, compressedURL))
                        observer.onCompleted()

                        DispatchQueue.main.async {
                            completedCount += 1

                            if completedCount == totalCount {
                                self.isCompressionCompleteRelay.accept(true)
                            }
                        }
                    }

                    if media.url.pathExtension.lowercased() == "jpg" || media.url.pathExtension.lowercased() == "png" {
                        if let imageData = try? Data(contentsOf: media.url),
                           let image = UIImage(data: imageData),
                           let compressedData = self.compressImage(image: image) {

                            let compressedURL = FileManager.default.temporaryDirectory
                                .appendingPathComponent(UUID().uuidString)
                                .appendingPathExtension("jpg")

                            do {
                                try compressedData.write(to: compressedURL)
                                onComplete(compressedURL)
                            } catch {
                                onComplete(media.url)
                            }
                        } else {
                            onComplete(media.url)
                        }
                    } else {
                        self.compressVideo(inputURL: media.url) { compressedURL in
                            onComplete(compressedURL ?? media.url)
                        }
                    }
                    return Disposables.create()
                }
            }
            .toArray()
            .asObservable()
            .map { compressedList in
                let sortedList = compressedList.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
                return sortedList
            }
    }

    private func uploadPost(caption: String, mediaItems: [MediaUploadData], gymName: String) -> Observable<Result<Void, Error>> {
        return self.myUserInfoUseCase.execute()
            .flatMap { user -> Single<Result<Void, Error>> in
                guard let user = user else {
                    return Single.just(.failure(CommonError.selfNil))
                }
                
                let postData = PostUploadData(
                    user: user,
                    gym: gymName,
                    caption: caption,
                    medias: mediaItems
                )
                
                return self.uploadPostUseCase.execute(data: postData)
                    .andThen(Single.just(.success(())))
                    .catch { error in Single.just(.failure(error)) }
            }
            .asObservable()
    }
}

extension UploadPostVMImpl {
    func compressImage(image: UIImage, quality: CGFloat = 0.3) -> Data? {
        return image.jpegData(compressionQuality: quality)
    }
    
    func compressVideo(inputURL: URL, completion: @escaping (URL?) -> Void) {
        let videoCompressor = LightCompressor()
        
        _ = videoCompressor.compressVideo(videos: [
            .init(
                source: inputURL,
                destination: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4"),
                configuration: .init(
                    quality: VideoQuality.medium,
                    videoBitrateInMbps: 2,
                    disableAudio: false,
                    keepOriginalResolution: false,
                    videoSize: nil
                )
            )
        ],
        progressQueue: .main,
        progressHandler: { progress in
        },
                                          
        completion: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .onSuccess(_, let path):
                print("비디오 압축 완료: \(path)")
                completion(path)
            case .onStart:
                print("압축 시작")
            case .onFailure(_, let error):
                print("비디오 압축 실패: \(error.localizedDescription)")
                completion(inputURL)
            case .onCancelled:
                print("비디오 압축 취소됨")
                completion(nil)
            }
        })
    }
}
