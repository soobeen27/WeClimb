//
//  CommentCellVM.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/6/24.
//

import Foundation

import FirebaseCore
import FirebaseFirestore
import RxCocoa
import RxSwift

class CommentCellVM {
    private let db = Firestore.firestore()
    var comment: Comment
    var post: Post
    var user: User
    
    let commentLikeList = BehaviorRelay<[String]>(value: [])
    
    init(user: User, comment: Comment, post: Post) {
        self.comment = comment
        self.post = post
        self.user = user
        fetchCommentLikeList()
    }
    
    func fetchCommentLikeList() {
        commentLikeList.accept(comment.like ?? [])
    }
    
    func likeComment(myUID: String) {
        let commentRef = self.db.collection("posts").document(post.postUID)
            .collection("comments").document(comment.commentUID)
        
        self.db.runTransaction { transaction, errorPointer in
            let commentSnapshot: DocumentSnapshot
            do {
                commentSnapshot = try transaction.getDocument(commentRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            var currentLikeList = commentSnapshot.data()?["like"] as? [String] ?? []
            
            if currentLikeList.contains([myUID]) {
                transaction.updateData(["like" : FieldValue.arrayRemove([myUID])], forDocument: commentRef)
                currentLikeList.removeAll { $0 == myUID }
            } else {
                transaction.updateData(["like" : FieldValue.arrayUnion([myUID])], forDocument: commentRef)
                currentLikeList.append(myUID)
            }
            return currentLikeList
        } completion: { [weak self] object, error in
            if let error = error {
                print("Error : \(error) ", #file, #function, #line)
                return
            } else if let likeList = object as? [String], let self {
                self.commentLikeList.accept(likeList)
            }
        }
    }


}
