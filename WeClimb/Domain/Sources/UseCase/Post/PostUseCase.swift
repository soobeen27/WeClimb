//
//  PostUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/19/25.
//

import Foundation

import Firebase
import RxSwift

protocol PostUseCase {
    func execute(postRefs: [DocumentReference]) -> Observable<[Post]>
}

struct PostUseCaseImpl: PostUseCase {
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    func execute(postRefs: [DocumentReference]) -> Observable<[Post]> {
        return postRepository.posts(postRefs: postRefs)
    }
}
