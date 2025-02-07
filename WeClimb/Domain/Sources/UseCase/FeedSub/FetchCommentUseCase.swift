//
//  FetchCommentUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/4/25.
//

import RxSwift

protocol FetchCommentUseCase {
    func execute(postUID: String, postOwner: String) -> Single<[Comment]>
}

class FetchCommentUseCaseImpl: FetchCommentUseCase {
    private let commentRepository: CommentRepository
    
    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func execute(postUID: String, postOwner: String) -> Single<[Comment]> {
        return commentRepository.fetchComments(postUID: postUID, postOwner: postOwner)
    }
}
