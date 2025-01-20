//
//  LikePostUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/17/25.
//
import Foundation

import RxSwift

protocol LikePostUseCase {
    func execute(myUID: String, postUID: String) -> Single<[String]>
}
public struct LikePostUseCaseImpl: LikePostUseCase {
    private let likePostRepository: LikePostRepository
    
    init(likePostRepository: LikePostRepository) {
        self.likePostRepository = likePostRepository
    }
    
    func execute(myUID: String, postUID: String) -> Single<[String]> {
        return likePostRepository.likePost(myUID: myUID, postUID: postUID)
    }
}
