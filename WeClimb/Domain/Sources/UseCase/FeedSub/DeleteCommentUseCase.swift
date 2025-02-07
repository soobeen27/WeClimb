//
//  DeleteCommentUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/4/25.
//

import RxSwift

protocol DeleteCommentUseCase {
    func execute(postUID: String, commentUID: String) -> Single<Void>
}

class DeleteCommentUseCaseImpl: DeleteCommentUseCase {
    private let commentRepository: CommentRepository
    
    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func execute(postUID: String, commentUID: String) -> Single<Void> {
        commentRepository.deleteComments(postUID: postUID, commentUID: commentUID)
    }
}
