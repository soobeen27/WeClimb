//
//  PostCollectionCellVM.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/13/25.
//

import Foundation

import RxSwift
import RxCocoa
import FirebaseFirestore

protocol PostCollectionCellInput {
    var postItem: PostItem { get }
    var likeButtonTap: ControlEvent<Void> { get }
}

protocol PostCollectionCellOutput {
    var user: Single<User> { get }
    var likeCount: BehaviorRelay<Int> { get }
    var isLike: BehaviorRelay<Bool?> { get }
    var mediaItems: Observable<[MediaItem]> { get }
}

protocol PostCollectionCellVM {
    func transform(input: PostCollectionCellInput) -> PostCollectionCellOutput
}

class PostCollectionCellVMImpl: PostCollectionCellVM {
    private let userInfoFromUIDUseCase: UserInfoFromUIDUseCase
    private let myUIDUseCase: MyUIDUseCase
    private let likePostUseCase: LikePostUseCase
    private let fetchMediasUseCase: FetchMediasUseCase
    
    private let disposeBag = DisposeBag()
    private var myUID: String?

    struct Input: PostCollectionCellInput {
        let postItem: PostItem
        let likeButtonTap: ControlEvent<Void>
    }
    
    struct Output: PostCollectionCellOutput {
        let user: Single<User>
        let likeCount: BehaviorRelay<Int>
        let isLike: BehaviorRelay<Bool?>
        let mediaItems: Observable<[MediaItem]>
    }

    init(userInfoFromUIDUseCase: UserInfoFromUIDUseCase, myUIDUseCase: MyUIDUseCase, likePostUseCase: LikePostUseCase, fetchMediasUseCase: FetchMediasUseCase) {
        self.userInfoFromUIDUseCase = userInfoFromUIDUseCase
        self.myUIDUseCase = myUIDUseCase
        self.likePostUseCase = likePostUseCase
        self.fetchMediasUseCase = fetchMediasUseCase
        setMyUID()
    }
    
    func transform(input: PostCollectionCellInput) -> PostCollectionCellOutput {
        let user = userInfoFromUIDUseCase.execute(uid: input.postItem.authorUID)
        let likeCount = BehaviorRelay(value: getLikeCount(likes: input.postItem.like))
        let isLike = BehaviorRelay(value: getIsLike(likes: input.postItem.like))

        input.likeButtonTap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                self.like(postUID: input.postItem.postUID)
                    .subscribe(onSuccess: { likes in
                        isLike.accept(self.getIsLike(likes: likes))
                        likeCount.accept(self.getLikeCount(likes: likes))
                    }, onFailure: { error in
                        print("좋아요 버튼 탭 에러 발생: \(error)")
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        guard let paths = input.postItem.medias else { return Output(user: user, likeCount: likeCount, isLike: isLike, mediaItems: Observable.error(FirebaseError.documentNil))
        }
        let refs = pathToRef(paths: paths)
        let medias = fetchMediasUseCase.execute(refs: refs).map { [weak self] medias in
            return medias.compactMap { media in
                self?.mediaToItem(media: media)
            }
        }.asObservable()
                
        
        return Output(user: user, likeCount: likeCount, isLike: isLike, mediaItems: medias)
    }
    
    private func mediaToItem(media: Media) -> MediaItem {
        return MediaItem(mediaUID: media.mediaUID, url: media.url, hold: media.hold, grade: media.grade, gym: media.gym, creationDate: media.creationDate, postRef: media.postRef, thumbnailURL: media.thumbnailURL, height: media.height, armReach: media.armReach)
    }
    
    private func getLikeCount(likes: [String]?) -> Int {
        likes?.count ?? 0
    }
    
    private func getIsLike(likes: [String]?) -> Bool? {
            guard let myUID = try? myUIDUseCase.execute() else { return nil}
            let isLike = likes?.contains([myUID]) ?? false
            return isLike
    }
    
    private func setMyUID() {
        do {
            self.myUID = try myUIDUseCase.execute()
        } catch {
            print(error)
            }
    }
    
    private func like(postUID: String) -> Single<[String]> {
        guard let myUID = self.myUID else { return Single.error(UserError.noID)}
        return likePostUseCase.execute(myUID: myUID, postUID: postUID)
    }
    
    private func pathToRef(paths: [String]) -> [DocumentReference] {
        return paths.map {
            Firestore.firestore().document($0)
        }
    }
}
