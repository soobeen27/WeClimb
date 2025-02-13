//
//  UploadPostVM.swift
//  WeClimb
//
//  Created by 강유정 on 2/11/25.
//

import RxSwift
import RxCocoa

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

 
        let userObservable = self.myUserInfoUseCase.execute().asObservable()

        userObservable
            .take(1)
            .subscribe(onNext: { [weak self] user in
                guard let self = self, let user = user else { return }

                let initialPostData = PostUploadData(
                    user: user, 
                    gym: input.gymName,
                    caption: "",
                    medias: input.mediaItems
                )

//            print("🔥 [INITIAL POST DATA] Firebase에 업로드할 데이터:")
//            print("   - User ID: \(String(describing: initialPostData.user.userName))")
//            print("   - Gym: \(String(describing: initialPostData.gym))")
//            print("   - Caption: (사용자 입력 대기 중)")
//            print("   - Media Count: \(initialPostData.medias.count)")
//
//        for (index, media) in initialPostData.medias.enumerated() {
//            print("   📸 [MEDIA \(index + 1)]")
//            print("      - File Name: \(String(describing: media.thumbnailURL))")
//            print("      - Grade & Hold: \(String(describing: media.grade)) , \(String(describing: media.hold))")
//            print("      - Captured At: \(String(describing: media.capturedAt))")
//        }
         })
         .disposed(by: disposeBag)
                      
        input.submitButtonTap
            .withLatestFrom(input.captionText)
            .flatMapLatest { [weak self] caption -> Observable<Result<Void, Error>> in
                guard let self = self else { return Observable.just(.failure(CommonError.selfNil)) }
                
                return self.myUserInfoUseCase.execute()
                    .flatMap { user -> Single<Result<Void, Error>> in
                        guard let user = user else {
                            return Single.just(.failure(CommonError.selfNil))
                        }
                        
                        let postData = PostUploadData(
                            user: user,
                            gym: input.gymName,
                            caption: caption,
                            medias: input.mediaItems
                        )
                        
//                        print("🔥 [POST DATA] Firebase에 업로드할 데이터:")
//                        print("   - User ID: \(String(describing: postData.user.userName))")
//                        print("   - Gym: \(String(describing: postData.gym))")
//                        print("   - Caption: \(String(describing: postData.caption))")
//                        print("   - Media Count: \(postData.medias.count)")
//                        
//                        for (index, media) in postData.medias.enumerated() {
//                            print("   📸 [MEDIA \(index + 1)]")
//                            print("      - File Name: \(String(describing: media.thumbnailURL))")
//                            print("      - grade hold: \(String(describing: media.grade)) , \(String(describing: media.hold))")
//                            print("      - Local capturedAt: \(String(describing: media.capturedAt))")
//                        }
                        
                        return self.uploadPostUseCase.execute(data: postData)
                            .andThen(Single.just(.success(())))
                            .catch { error in Single.just(.failure(error)) }
                    }
                    .asObservable()
            }
            .bind(to: uploadResult)
            .disposed(by: disposeBag)
        
        return Output(uploadResult: uploadResult.asObservable())
    }
}
