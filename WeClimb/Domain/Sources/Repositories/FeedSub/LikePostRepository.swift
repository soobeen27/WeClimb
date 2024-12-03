//
//  LikePostRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import Foundation

import RxSwift

protocol LikePostRepository {
    func likePost(myUID: String, postUID: String) -> Single<[String]>
}
