//
//  PostCollectionCellVM.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/13/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol PostCollectionCellInput {
    var postItem: PostItem { get }
    var likeButtonTap: ControlEvent<Void> { get }
}

protocol PostCollectionCellOutput {
    var user: Single<User> { get }
    var likeCount: BehaviorRelay<Int> { get }
    var isLike: BehaviorRelay<Bool?> { get }
//    var likeResult: Single<[String]> { get }
}

protocol PostCollectionCellVM {
    func transform(input: PostCollectionCellInput) -> PostCollectionCellOutput
}

class PostCollectionCellVMImpl: PostCollectionCellVM {
    private let userInfoFromUIDUseCase: UserInfoFromUIDUseCase
    private let myUIDUseCase: MyUIDUseCase
    private let likePostUseCase: LikePostUseCase
    
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
//        let likeResult: Single<[String]>
    }

    init(userInfoFromUIDUseCase: UserInfoFromUIDUseCase, myUIDUseCase: MyUIDUseCase, likePostUseCase: LikePostUseCase) {
        self.userInfoFromUIDUseCase = userInfoFromUIDUseCase
        self.myUIDUseCase = myUIDUseCase
        self.likePostUseCase = likePostUseCase
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
        
        return Output(user: user, likeCount: likeCount, isLike: isLike)
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
}
