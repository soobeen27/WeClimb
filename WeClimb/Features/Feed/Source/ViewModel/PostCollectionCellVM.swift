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
}

protocol PostCollectionCellOutput {
    var user: Single<User> { get }
}

protocol PostCollectionCellVM {
    func transform(input: PostCollectionCellInput) -> PostCollectionCellOutput
}

class PostCollectionCellVMImpl: PostCollectionCellVM {
    private let userInfoFromUIDUseCase: UserInfoFromUIDUseCase

    struct Input: PostCollectionCellInput {
        let postItem: PostItem
    }
    
    struct Output: PostCollectionCellOutput {
        let user: Single<User>
    }

    init(userInfoFromUIDUseCase: UserInfoFromUIDUseCase) {
        self.userInfoFromUIDUseCase = userInfoFromUIDUseCase
    }
    
    func transform(input: PostCollectionCellInput) -> PostCollectionCellOutput {
        let user = userInfoFromUIDUseCase.execute(uid: input.postItem.authorUID)
        return Output(user: user)
    }
}
