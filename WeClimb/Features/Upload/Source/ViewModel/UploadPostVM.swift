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
    var uploadResult: Observable<Result<Void, Error>> { get }
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
        let uploadResult: Observable<Result<Void, Error>>
    }
    
    private let disposeBag = DisposeBag()
    private let uploadPostUseCase: UploadPostUseCase
    private let myUserInfoUseCase: MyUserInfoUseCase
    
    init(uploadPostUseCase: UploadPostUseCase, myUserInfoUseCase: MyUserInfoUseCase) {
        self.uploadPostUseCase = uploadPostUseCase
        self.myUserInfoUseCase = myUserInfoUseCase
    }
    
    func transform(input: UploadPostInput) -> UploadPostOutput {
        let uploadResult = PublishRelay<Result<Void, Error>>()
        let captionTextRelay = BehaviorRelay<String>(value: "")
        let submitTrigger = PublishRelay<Void>()
        let compressedMediaRelay = BehaviorRelay<[URL]?>(value: nil)
        let isSubmitPending = BehaviorRelay<Bool>(value: false)
        
        input.submitButtonTap
            .do(onNext: { _ in
                isSubmitPending.accept(true)
            })
            .bind(to: submitTrigger)
            .disposed(by: disposeBag)
        
        input.captionText
            .bind(to: captionTextRelay)
            .disposed(by: disposeBag)
        
        compressMediaItems(input.mediaItems)
            .subscribe(onNext: { compressedMediaURLs in
                compressedMediaRelay.accept(compressedMediaURLs)
                
                if isSubmitPending.value {
                    submitTrigger.accept(())
                    isSubmitPending.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(submitTrigger, compressedMediaRelay)
            .compactMap { _, compressedMediaURLs -> [URL]? in
                return compressedMediaURLs
            }
            .withLatestFrom(Observable.combineLatest(captionTextRelay, compressedMediaRelay.compactMap { $0 }))
            .flatMapLatest { [weak self] (caption: String, compressedMediaURLs: [URL]) -> Observable<Result<Void, Error>> in
                guard let self = self else { return Observable.just(.failure(CommonError.selfNil)) }
                
                let updatedMediaItems: [MediaUploadData] = zip(input.mediaItems, compressedMediaURLs).map { original, compressedURL in
                    MediaUploadData(
                        url: compressedURL,
                        hold: original.hold,
                        grade: original.grade,
                        thumbnailURL: original.thumbnailURL,
                        capturedDate: original.capturedDate
                    )
                }
                
                return self.uploadPost(caption: caption, mediaItems: updatedMediaItems, gymName: input.gymName)
            }
            .observe(on: MainScheduler.instance)
            .bind(to: uploadResult)
            .disposed(by: disposeBag)
        
        return Output(uploadResult: uploadResult.asObservable())
    }
    
    private func compressMediaItems(_ mediaItems: [MediaUploadData]) -> Observable<[URL]> {
        return Observable.from(mediaItems.enumerated())
            .flatMap { (index, media) -> Observable<(Int, URL)> in
                return Observable.create { observer in
                    if media.url.pathExtension.lowercased() == "jpg" || media.url.pathExtension.lowercased() == "png" {
                        if let imageData = try? Data(contentsOf: media.url),
                           let image = UIImage(data: imageData),
                           let compressedData = self.compressImage(image: image) {

                            let compressedURL = FileManager.default.temporaryDirectory
                                .appendingPathComponent(UUID().uuidString)
                                .appendingPathExtension("jpg")

                            do {
                                try compressedData.write(to: compressedURL)
                                observer.onNext((index, compressedURL))
                            } catch {
                                observer.onNext((index, media.url))
                            }
                        } else {
                            observer.onNext((index, media.url))
                        }
                    }
                    else {
                        self.compressVideo(inputURL: media.url) { compressedURL in
                            observer.onNext((index, compressedURL ?? media.url))
                            observer.onCompleted()
                        }
                    }
                    return Disposables.create()
                }
            }
            .toArray()
            .map { compressedList in
                compressedList.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
            }
            .asObservable()
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
