//
//  File.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/4/24.
//

import Foundation

import FirebaseCore
import FirebaseFirestore
import RxSwift
import RxCocoa

class CommentVM {
    
    private let db = Firestore.firestore()
    let post: Post
    var comments = BehaviorRelay<[Comment]>(value: [])
//    var commentLikeList = BehaviorRelay<[String]>(value: [])
    
    let disposeBag = DisposeBag()
    
    init(post: Post) {
        self.post = post
        bindComments()
    }
    
    // MARK: 댓글달기
    /// 댓글 다는 함수임
    /// - Parameters:
    ///   - userUID: 로그인된 유저 유아이디;
    ///   - postUid: 댓글 달려는 포스트 유아이디
    ///   - content: 댓글 내용
    func addComment(userUID: String, fromPostUid postUid: String, content: String) {
        let commentUID = UUID().uuidString
        let postRef = db.collection("posts").document(postUid)
        let userRef = self.db.collection("users").document(userUID)
        let commentRef = db.collection("posts").document(postUid).collection("comments").document(commentUID)
        let comment = Comment(commentUID: commentUID, authorUID: userUID, content: content, creationDate: Date(), like: nil, postRef: postRef)
        do {
            try commentRef.setData(from: comment) { [weak self] error in
                guard let self else { return }
                if let error = error {
                    print("댓글 다는중 오류\(error)")
                    return
                }
                userRef.updateData(["comments" : FieldValue.arrayUnion([commentRef])])
                bindComments()
            }
        } catch {
            print("댓글 작성중 에러")
        }
    }
    
    // MARK: 특정 포스트의 댓글 가져오기
    func bindComments() {
        fetchComments(postUID: post.postUID, postOwner: post.authorUID)
            .subscribe(onSuccess: { [weak self] comments in
                guard let self else { return }
                self.comments.accept(comments)
                print(comments)
            }, onFailure: { error in
                print("Error - \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func fetchComments(postUID: String, postOwner: String) -> Single<[Comment]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            let commentsRef = self.db.collection("posts")
                .document(postUID)
                .collection("comments")
            
            commentsRef.getDocuments { snapshot, error in
                if let error = error {
                    print("댓글 가져오기 오류: \(error)")
                    single(.failure(error))
                    return
                }
                guard let documents = snapshot?.documents else {
                    single(.failure(GetDocumentError.noField))
                    return
                }
                let comments: [Comment] = documents.compactMap { document in
                    do {
                        return try document.data(as: Comment.self)
                    } catch {
                        single(.failure(GetDocumentError.failDecoding))
                        return nil
                    }
                }
                let sortedComments = comments.sorted { $0.creationDate > $1.creationDate }
                single(.success(sortedComments))
            }
            return Disposables.create()
        }
    }
    
    func deleteComments(commentUID: String) {
        let postUID = post.postUID
        let commentRef = db.collection("posts")
            .document(postUID)
            .collection("comments")
            .document(commentUID)
        
        commentRef.delete { [weak self] error in
            guard let self else { return }
            if let error = error {
                print("Error - deleting comment \(error)")
                return
            }
            var currentComments = self.comments.value
            
            currentComments.removeAll { comment in
                comment.commentUID == commentUID
            }
            
            self.comments.accept(currentComments)
        }
    }
    
//    func fetchCommentLikeList(commentUID: String) {
//        let commentRef = self.db.collection("post").document(post.postUID)
//            .collection("comments").document(commentUID)
//        
//        commentRef.getDocument { [weak self] snapshot, error in
//            if let error = error {
//                print("Error - fetchCommentLikeList \(error)")
//                return
//            }
//            guard let self else { return }
//            let data = snapshot?.data()?["like"] as? [String] ?? []
//            self.commentLikeList.accept(data)
//        } 
//    }
//    
//    func likeComment(myUID: String, postUID: String, commentUID: String) {
//        let commentRef = self.db.collection("posts").document(postUID)
//            .collection("comments").document(commentUID)
//        
//        self.db.runTransaction { transaction, errorPointer in
//            let commentSnapshot: DocumentSnapshot
//            do {
//                commentSnapshot = try transaction.getDocument(commentRef)
//            } catch let fetchError as NSError {
//                errorPointer?.pointee = fetchError
//                return nil
//            }
//            var currentLikeList = commentSnapshot.data()?["like"] as? [String] ?? []
//            
//            if currentLikeList.contains([myUID]) {
//                transaction.updateData(["like" : FieldValue.arrayRemove([myUID])], forDocument: commentRef)
//                currentLikeList.removeAll { $0 == myUID }
//            } else {
//                transaction.updateData(["like" : FieldValue.arrayUnion([myUID])], forDocument: commentRef)
//                currentLikeList.append(myUID)
//            }
//            return currentLikeList
//        } completion: { [weak self] object, error in
//            if let error = error {
//                print("Error : \(error) ", #file, #function, #line)
//                return
//            } else if let likeList = object as? [String], let self {
//                self.commentLikeList.accept(likeList)
//            }
//        }
//    }
}
