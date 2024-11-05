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
    
    let disposeBag = DisposeBag()
    
    init(post: Post) {
        self.post = post
        bindComments()
    }
    
    // MARK: 댓글달기
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
    //    func fetchComments(postUID: String, postOwner: String, completion: @escaping ([Comment]?) -> Void) {
    //        let postRef = db.collection("users").document(postOwner).collection("posts").document(postUID).collection("comments")
    //
    //        postRef.getDocuments { snapshot, error in
    //            if let error = error {
    //                print("댓글 가져오기 오류: \(error)")
    //                completion(nil)
    //                return
    //            }
    //            guard let documents = snapshot?.documents else {
    //                completion(nil)
    //                return
    //            }
    //            let comments: [Comment] = documents.compactMap { document in
    //                do {
    //                    return try document.data(as: Comment.self)
    //                } catch {
    //                    return nil
    //                }
    //            }
    //            let sortedComments = comments.sorted { $0.creationDate > $1.creationDate }
    //
    //            completion(sortedComments)
    //        }
    //    }
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
            //            let postRef = self.db.collection("posts")
            //                .document(postUID)
            //                .collection("posts")
            //                .document(postUID)
            //                .collection("comments")
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
}
