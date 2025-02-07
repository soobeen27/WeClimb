//
//  PostCommentVM.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/4/25.
//

import FirebaseFirestore
import RxSwift

protocol PostCommentVM {
    func transform(input: PostCommentInput) -> PostCommentOutput
}

protocol PostCommentInput {
    var postItem: Observable<PostItem> { get }
}

protocol PostCommentOutput {
    
}

struct CommentItem: Hashable {
    let commentUID: String
    let authorUID: String
    let content: String
    let creationDate: Date
    let like: [String]?
    let postRef: DocumentReference
}

class PostCommentVMImpl: PostCommentVM {
    private let addCommentUseCase: AddCommentUseCase
    private let fetchCommentUseCase: FetchCommentUseCase
    private let deleteCommentUseCase: DeleteCommentUseCase
    private let userInfoFromUIDUseCase: UserInfoFromUIDUseCase

    init(addCommentUseCase: AddCommentUseCase, fetchCommentUseCase: FetchCommentUseCase, deleteCommentUseCase: DeleteCommentUseCase, userInfoFromUIDUseCase: UserInfoFromUIDUseCase) {
        self.addCommentUseCase = addCommentUseCase
        self.fetchCommentUseCase = fetchCommentUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
        self.userInfoFromUIDUseCase = userInfoFromUIDUseCase
    }
    
    struct Input: PostCommentInput {
        let postItem: Observable<PostItem>
    }
    
    struct Output: PostCommentOutput {
        
    }
    
    
    func transform(input: PostCommentInput) -> PostCommentOutput {
        return Output()
    }
}
