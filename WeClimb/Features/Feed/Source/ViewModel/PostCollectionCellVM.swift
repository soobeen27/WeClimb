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
    var likes: Int { get }
    var isLike: Bool? { get }
    var likeResult: Single<[String]> { get }
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
        let likes: Int
        let isLike: Bool?
        let likeResult: Single<[String]>
    }

    init(userInfoFromUIDUseCase: UserInfoFromUIDUseCase, myUIDUseCase: MyUIDUseCase, likePostUseCase: LikePostUseCase) {
        self.userInfoFromUIDUseCase = userInfoFromUIDUseCase
        self.myUIDUseCase = myUIDUseCase
        self.likePostUseCase = likePostUseCase
    }
    
    func transform(input: PostCollectionCellInput) -> PostCollectionCellOutput {
        let user = userInfoFromUIDUseCase.execute(uid: input.postItem.authorUID)
        let likeCount = getLikeCount(likes: input.postItem.like)
        let isLike = getIsLike(likes: input.postItem.like)
        let likeResult = input.likeButtonTap.compactMap { [weak self] _ in
            return self?.like(postUID: input.postItem.postUID)
        }.flatMap { $0.asObservable() }
            .asSingle()
        
        return Output(user: user, likes: likeCount, isLike: isLike, likeResult: likeResult )
    }
    
    private func getLikeCount(likes: [String]?) -> Int {
        likes?.count ?? 0
    }
    
    private func getIsLike(likes: [String]?) -> Bool? {
            guard let myUID = try? myUIDUseCase.execute() else { return nil}
            let isLike = likes?.contains([myUID]) ?? false
            return isLike
    }
    
    private func like(postUID: String) -> Single<[String]> {
        guard let myUID = self.myUID else { return Single.error(UserError.noID)}
        return likePostUseCase.execute(myUID: myUID, postUID: postUID)
    }
}
