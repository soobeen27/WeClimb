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
    var currentMediaIndex: BehaviorRelay<Int> { get }
    var commentButtonTap: ControlEvent<Void> { get }
    var additionalButtonTap: ControlEvent<Void> { get }
    var userTap: Observable<Void> { get }
    var gymTap: Observable<Void> { get }
}

protocol PostCollectionCellOutput {
    var user: Single<User> { get }
    var likeCount: BehaviorRelay<Int> { get }
    var isLike: BehaviorRelay<Bool?> { get }
    var mediaItems: Observable<[MediaItem]> { get }
    var levelHolds: Observable<(level: LHColors?, hold: LHColors?)> { get }
    var currentPost: BehaviorRelay<PostItem?> { get }
    var addtionalButtonTapData: Observable<(postItem: PostItem, isMine: Bool)?> { get }
    var commentCount: Observable<Int> { get }
    var gymTapInfo: Observable<(gymName: String?, level: LHColors?, hold: LHColors?)> { get }
    var userTapInfo: Observable<String> { get }
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
        let currentMediaIndex: BehaviorRelay<Int>
        let commentButtonTap: ControlEvent<Void>
        let additionalButtonTap: ControlEvent<Void>
        let userTap: Observable<Void>
        let gymTap: Observable<Void>
    }
    
    struct Output: PostCollectionCellOutput {
        let user: Single<User>
        let likeCount: BehaviorRelay<Int>
        let isLike: BehaviorRelay<Bool?>
        let mediaItems: Observable<[MediaItem]>
        let levelHolds: Observable<(level: LHColors?, hold: LHColors?)>
        let currentPost: BehaviorRelay<PostItem?>
        let addtionalButtonTapData: Observable<(postItem: PostItem, isMine: Bool)?>
        let commentCount: Observable<Int>
        let gymTapInfo: Observable<(gymName: String?, level: LHColors?, hold: LHColors?)>
        let userTapInfo: Observable<String>
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
        let commentCount = input.postItem.commentCount ?? 0

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
        guard let paths = input.postItem.medias else { return Output(
            user: user,
            likeCount: likeCount,
            isLike: isLike,
            mediaItems: Observable.error(FirebaseError.documentNil),
            levelHolds: Observable.just((nil, nil)),
            currentPost: BehaviorRelay<PostItem?>.init(value: nil),
            addtionalButtonTapData: Observable.just(nil),
            commentCount: Observable.just(0),
            gymTapInfo: Observable.just((gymName: "", level: nil, hold: nil)),
            userTapInfo: Observable.just("")
        )}

        let refs = pathToRef(paths: paths)
        let medias = fetchMediasUseCase.execute(refs: refs).map { [weak self] medias in
            return medias.compactMap { media in
                self?.mediaToItem(media: media)
            }
        }.asObservable()
        let levelHolds = input.currentMediaIndex.flatMap { index in
            return medias.compactMap { (medias) -> (level: LHColors?, hold: LHColors?) in
                if medias.isEmpty || index >= medias.count {
                    return (nil, nil)
                }
                guard let level = medias[index].grade, let hold = medias[index].hold else { return (nil, nil) }
                let levelLH = LHColors.fromEng(level)
                let holdLH = LHColors.fromHoldEng(hold)
                return (level: levelLH, hold: holdLH)
            }
        }
        
        let currentPost = BehaviorRelay<PostItem?>(value: nil)

        input.commentButtonTap
            .map { input.postItem }
            .bind(to: currentPost)
            .disposed(by: disposeBag)
//        (postItem: PostItem, type: FeedMenuSelection)
        let addtionalButtonTapData = input.additionalButtonTap
            .flatMap{ [weak self] () -> Observable<(postItem: PostItem, isMine: Bool)?> in
                guard let self else { return Observable.just(nil) }
                let isMine = self.isMyPost(uid: input.postItem.authorUID)
                return Observable.just((postItem: input.postItem, isMine: isMine))
            }
        
//        input.additionalButtonTap
//            .subscribe(onNext: { [weak self] in
//                guard let self else { return }
//                self.isMyPost(uid: input.postItem.authorUID)
//            })
//            .disposed(by: disposeBag)
        
        let gymLH = input.gymTap.flatMap {
            levelHolds.map {
                (gymName: input.postItem.gym, level: $0.level, hold: $0.hold)
            }
        }
        let userName = input.userTap.flatMap{
            user.asObservable().map { $0.userName ?? "" }
        }
//        let gymLH = levelHolds.map {
//            (gymName: input.postItem.gym, level: $0.level, hold: $0.hold)
//        }
        
//        let userName = user.asObservable().map { $0.userName ?? "" }
                
        return Output(
            user: user, likeCount: likeCount,
            isLike: isLike, mediaItems: medias,
            levelHolds: levelHolds,
            currentPost: currentPost,
            addtionalButtonTapData: addtionalButtonTapData,
            commentCount: Observable.just(commentCount),
            gymTapInfo: gymLH,
            userTapInfo: userName
            
        )
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
    
    private func levelStringToImage(_ string: String) -> UIImage {
        LHColors.fromEng(string).toImage()
    }
    private func holdStringToImage(_ string: String) -> UIImage {
        LHColors.fromHoldEng(string).toImage()
    }
    
    private func isMyPost(uid: String) -> Bool {
        guard let myUID else { return false }
        return myUID == uid
    }
}
