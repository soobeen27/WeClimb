//
//  CommentDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/28/24.
//

import Foundation
import Firebase
import RxSwift

protocol CommentDataSource {
    func addComment(postUID: String, content: String) -> Single<Void>
    func fetchComments(postUID: String, postOwner: String) -> Single<[Comment]>
    func deleteComments(postUID: String, commentUID: String) -> Single<Void>
}

class CommentDataSourceImpl: CommentDataSource {
    private let db = Firestore.firestore()
    // MARK: 댓글달기
    func addComment(postUID: String, content: String) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self,
                  let uid = try? FirestoreHelper.userUID()
            else { return Disposables.create() }
            
            let commentUID = UUID().uuidString
            let postRef = db.collection("posts").document(postUID)
            let userRef = self.db.collection("users").document(uid)
            let commentRef = db.collection("posts").document(postUID).collection("comments").document(commentUID)
            let comment = Comment(commentUID: commentUID, authorUID: uid, content: content, creationDate: Date(), like: nil, postRef: postRef)
            do {
                try commentRef.setData(from: comment) { error in
                    if let error = error {
                        print("댓글 다는중 오류\(error)")
                        single(.failure(error))
                        return
                    }
                    userRef.updateData(["comments" : FieldValue.arrayUnion([commentRef])])
                    single(.success(()))
                }
            } catch {
                print("댓글 작성중 에러")
                single(.failure(error))
            }
            
            
            return Disposables.create()
        }

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
    
    func deleteComments(postUID: String, commentUID: String) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            let commentRef = self.db.collection("posts")
                .document(postUID)
                .collection("comments")
                .document(commentUID)
            
            commentRef.delete { error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                single(.success(()))
            }
            return Disposables.create()
        }
    }
}
