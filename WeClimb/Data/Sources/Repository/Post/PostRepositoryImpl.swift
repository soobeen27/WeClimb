//
//  PostRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import Firebase
import RxSwift

final class PostRepositoryImpl: PostRepository {
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    func posts(postRefs: [DocumentReference]) -> Observable<[Post]> {
        return postRepository.posts(postRefs: postRefs)
    }
}
