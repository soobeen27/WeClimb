//
//  LikeVM.swift
//  WeClimb
//
//  Created by 김솔비 on 10/18/24.
//

import RxSwift
import RxCocoa
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class LikeViewModel {
    
    private let disposedBag = DisposeBag()
    private let db = Firestore.firestore()
    
    let post: Post
    
    let postLikeList = BehaviorRelay<[String]>(value: [])
    let error = PublishSubject<Error>()
    
    init(post: Post) {
        self.post = post
        fetchLikeList()
    }
//    func likePost(myUID: String, postUID: String) -> Single<[String]> {
//        return Single.create(subscribe: { [weak self] single in
//            guard let self else {
//                single(.failure(CommonError.noSelf))
//                return Disposables.create()
//            }
//            let postRef = self.db.collection("posts").document(postUID)
//            self.db.runTransaction { transaction, errorPointer in
//                let postSnapshot: DocumentSnapshot
//                do {
//                    postSnapshot = try transaction.getDocument(postRef)
//                } catch let fetchError as NSError {
//                    errorPointer?.pointee = fetchError
//                    single(.failure(fetchError as Error))
//                    return nil
//                }
//                var currentLikeList = postSnapshot.data()?["like"] as? [String] ?? []
//                
//                if currentLikeList.contains([myUID]) {
//                    transaction.updateData(["like" : FieldValue.arrayRemove([myUID])], forDocument: postRef)
//                    currentLikeList.removeAll { $0 == myUID }
//                } else {
//                    transaction.updateData(["like" : FieldValue.arrayUnion([myUID])], forDocument: postRef)
//                    currentLikeList.append(myUID)
//                }
//                return currentLikeList
//            } completion: { object, error in
//                if let error = error {
//                    print("Error : \(error) ", #file, #function, #line)
//                    single(.failure(error))
//                    return
//                } else if let likeList = object as? [String] {
//                    single(.success(likeList))
//                    self.postLikeList.accept(likeList)
//                }
//            }
//            return Disposables.create()
//        })
//    }
    func fetchLikeList() {
        postLikeList.accept(post.like ?? [])
    }
  
    func likePost(myUID: String)  {
        let postRef = db.collection("posts").document(post.postUID)
            self.db.runTransaction { transaction, errorPointer in
                let postSnapshot: DocumentSnapshot
                do {
                    postSnapshot = try transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                var currentLikeList = postSnapshot.data()?["like"] as? [String] ?? []
                
                if currentLikeList.contains([myUID]) {
                    transaction.updateData(["like" : FieldValue.arrayRemove([myUID])], forDocument: postRef)
                    currentLikeList.removeAll { $0 == myUID }
                } else {
                    transaction.updateData(["like" : FieldValue.arrayUnion([myUID])], forDocument: postRef)
                    currentLikeList.append(myUID)
                }
                return currentLikeList
            } completion: { object, error in
                if let error = error {
                    print("Error : \(error) ", #file, #function, #line)
                    return
                } else if let likeList = object as? [String] {
                    self.postLikeList.accept(likeList)
                }
            }
    }
//    func likePost(myUID: String, postUID: String)  {
//            let postRef = db.collection("posts").document(postUID)
//            self.db.runTransaction { transaction, errorPointer in
//                let postSnapshot: DocumentSnapshot
//                do {
//                    postSnapshot = try transaction.getDocument(postRef)
//                } catch let fetchError as NSError {
//                    errorPointer?.pointee = fetchError
//                    return nil
//                }
//                var currentLikeList = postSnapshot.data()?["like"] as? [String] ?? []
//                
//                if currentLikeList.contains([myUID]) {
//                    transaction.updateData(["like" : FieldValue.arrayRemove([myUID])], forDocument: postRef)
//                    currentLikeList.removeAll { $0 == myUID }
//                } else {
//                    transaction.updateData(["like" : FieldValue.arrayUnion([myUID])], forDocument: postRef)
//                    currentLikeList.append(myUID)
//                }
//                return currentLikeList
//            } completion: { object, error in
//                if let error = error {
//                    print("Error : \(error) ", #file, #function, #line)
//                    return
//                } else if let likeList = object as? [String] {
//                    self.postLikeList.accept(likeList)
//                }
//            }
//    }
}
