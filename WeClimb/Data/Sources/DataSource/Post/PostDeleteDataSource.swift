//
//  PostDeleteDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/11/25.
//
import FirebaseFirestore
import FirebaseAuth
import RxSwift

protocol PostDeleteDataSource {
    func deletePost(uid: String) -> Single<Void>
}

class PostDeleteDataSourceImpl: PostDeleteDataSource {
    private let db = Firestore.firestore()

    func deletePost(uid: String) -> Single<Void> {
        guard let user = Auth.auth().currentUser else {
            return Single.create {
                $0(.failure(UserError.logout))
                return Disposables.create()
            }
        }
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            let userRef = self.db.collection("users").document(user.uid)
            let postRef = self.db.collection("posts").document(uid)
            
            userRef.updateData(["posts" : FieldValue.arrayRemove([postRef])]) { error in
                if let error = error {
                    print("Error - Deleting Post Reference: \(error)")
                    single(.failure(error))
                    return
                }
                print("Post Reference deleted Successfully!")
                postRef.delete { error in
                    if let error = error {
                        print("Error - Deleting Post: \(error)")
                        single(.failure(error))
                        return
                    }
                    single(.success(()))
                }
            }
            return Disposables.create()
        }
    }
}
