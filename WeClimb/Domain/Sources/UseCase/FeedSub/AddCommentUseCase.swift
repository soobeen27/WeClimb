//
//  addCommentUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/4/25.
//

import RxSwift

protocol AddCommentUseCase {
    func execute(postUID: String, content: String) -> Single<Void>
}

struct AddCommentUseCaseImpl: AddCommentUseCase {
    private let commentRepository: CommentRepository
    
    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func execute(postUID: String, content: String) -> Single<Void> {
        return commentRepository.addCommnet(postUID: postUID, content: content)
    }
}
