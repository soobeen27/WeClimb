//
//  UserDeleteDataSource.swift
//  WeClimb
//
//  Created by 머성이 on 11/29/24.
//

import Foundation

import RxSwift
import Firebase
import FirebaseAuth
import FirebaseStorage

protocol UserDeleteDataSource {
    func userDelete() -> Completable
}

final class UserDeleteDataSourceImpl: UserDeleteDataSource {
    
    private let db = Firestore.firestore()
    
    func userDelete() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self, let user = Auth.auth().currentUser else {
                completable(.error(UserStateError.notAuthenticated))
                return Disposables.create()
            }
            
            user.delete { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    completable(.error(UserStateError.notAuthenticated))
                    return
                }
                print("authentication 성공적으로 계정 삭제")
                
                let userRef = self.db.collection("users").document(user.uid)
                userRef.delete { error in
                    if let error = error {
                        completable(.error(FirebaseError.firestoreFailure(error.localizedDescription)))
                    } else {
                        print("firestore 성공적으로 계정 삭제")
                        completable(.completed)
                    }
                }
            }
            return Disposables.create()
        }
    }
}


