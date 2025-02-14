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
        input.captionText
            .bind(to: captionTextRelay)
            .disposed(by: disposeBag)
        
        let compressedMediaObservable = compressMediaItems(input.mediaItems)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
        input.submitButtonTap
            .withLatestFrom(Observable.combineLatest(captionTextRelay, compressedMediaObservable))
            .flatMapLatest { [weak self] (caption, compressedMediaURLs) -> Observable<Result<Void, Error>> in
                guard let self = self else { return Observable.just(.failure(CommonError.selfNil)) }
                
                let updatedMediaItems = zip(input.mediaItems, compressedMediaURLs).map { original, compressedURL in
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
        return Observable.create { observer in
            let dispatchQueue = DispatchQueue(label: "mediaCompressionQueue", qos: .background)
            dispatchQueue.async {
                var compressedURLs = [URL]()
                let dispatchGroup = DispatchGroup()
                
                for media in mediaItems {
                    let originalURL = media.url
                    dispatchGroup.enter()

                    if self.isImage(url: originalURL) {
                        if let imageData = try? Data(contentsOf: originalURL),
                           let image = UIImage(data: imageData),
                           let compressedData = self.compressImage(image: image) {

                            let compressedURL = FileManager.default.temporaryDirectory
                                .appendingPathComponent(UUID().uuidString)
                                .appendingPathExtension("jpg")

                            do {
                                try compressedData.write(to: compressedURL)
                                compressedURLs.append(compressedURL)
                            } catch {
                                compressedURLs.append(originalURL)
                            }
                        } else {
                            compressedURLs.append(originalURL)
                        }
                        dispatchGroup.leave()

                    } else if self.isVideo(url: originalURL) {
                        self.compressVideo(inputURL: originalURL) { compressedURL in
                            if let compressedURL = compressedURL {
                                compressedURLs.append(compressedURL)
                            } else {
                                compressedURLs.append(originalURL)
                            }
                            dispatchGroup.leave()
                        }
                    } else {
                        compressedURLs.append(originalURL)
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    observer.onNext(compressedURLs)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }


    private func isImage(url: URL) -> Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "heic"]
        return imageExtensions.contains(url.pathExtension.lowercased())
    }
    
    private func isVideo(url: URL) -> Bool {
        let videoExtensions = ["mp4", "mov", "avi"]
        return videoExtensions.contains(url.pathExtension.lowercased())
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
