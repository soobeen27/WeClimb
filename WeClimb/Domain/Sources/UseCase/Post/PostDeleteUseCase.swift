//
//  PostDeleteUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/11/25.
//
import RxSwift

protocol PostDeleteUseCase {
    func execute(uid: String) -> Single<Void>
}

struct PostDeleteUseCaseImpl: PostDeleteUseCase {
    let postDeleteRepository: PostDeleteRepository
    
    init(postDeleteRepository: PostDeleteRepository) {
        self.postDeleteRepository = postDeleteRepository
    }
    
    func execute(uid: String) -> Single<Void> {
        postDeleteRepository.deletePost(uid: uid)
    }
}


