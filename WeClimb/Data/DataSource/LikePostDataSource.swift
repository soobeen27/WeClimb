//
//  LikePostDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/2/24.
//

import Foundation
import RxSwift
import Firebase

protocol LikePostDataSource {
    
}

class LikePostDataSourceImpl {
    private let db = Firestore.firestore()
    
    func likePost(myUID: String, postUID: String) -> Single<[String]>  {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CommonError.selfNil))
                return Disposables.create()
            }
            let postRef = self.db.collection("posts").document(postUID)
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
                    single(.failure(error))
                    return
                } else if let likeList = object as? [String] {
                    single(.success(likeList))
                }
            }
            return Disposables.create()
        }
    }
    
}

