//
//  CommentRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

final class CommentRepositoryImpl: CommentRepository {
    private let commentDataSource: CommentDataSource
    
    init(commentDataSource: CommentDataSource) {
        self.commentDataSource = commentDataSource
    }

    func AddCommnet(postUID: String, content: String) -> Single<Void> {
        return commentDataSource.addComment(postUID: postUID, content: content)
    }
    
    func FetchComments(postUID: String, postOwner: String) -> Single<[Comment]> {
        return commentDataSource.fetchComments(postUID: postUID, postOwner: postOwner)
    }
    
    func DeleteComments(postUID: String, commentUID: String) -> Single<Void> {
        return commentDataSource.deleteComments(postUID: postUID, commentUID: commentUID)
    }
}
