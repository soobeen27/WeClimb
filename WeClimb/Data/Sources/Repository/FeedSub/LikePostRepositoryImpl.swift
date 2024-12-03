//
//  LikePostRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import Foundation

import RxSwift

final class LikePostRepositoryImpl: LikePostRepository {
    private let likePostDataSource: LikePostDataSource
    
    init(likePostDataSource: LikePostDataSource) {
        self.likePostDataSource = likePostDataSource
    }
    
    func likePost(myUID: String, postUID: String) -> Single<[String]> {
        return likePostDataSource.likePost(myUID: myUID, postUID: postUID)
    }
}
