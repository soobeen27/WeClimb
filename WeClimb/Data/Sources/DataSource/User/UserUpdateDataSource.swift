//
//  UserUpdateDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/27/24.
//

import Foundation

import RxSwift
import Firebase
import FirebaseAuth
import FirebaseStorage

protocol UserUpdateDataSource {
    func updateUser<T>(with data: T, for field: UserUpdate) -> Completable
    func uploadProfileImageToStorage(imageURL: URL) -> Single<URL>
}

final class UserUpdateDataSourceImpl: UserUpdateDataSource {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func updateUser<T>(with data: T, for field: UserUpdate) -> Completable {
        return Completable.create { completable in
            do {
                let userUID = try FirestoreHelper.userUID()
                let userRef = self.db.collection("users").document(userUID)
                
                userRef.updateData([field.rawValue: data]) { error in
                    if let error = error {
                        completable(.error(error))
                    } else {
                        completable(.completed)
                    }
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func uploadProfileImageToStorage(imageURL: URL) -> Single<URL> {
        return Single<URL>.create { single in
            do {
                let userUID = try FirestoreHelper.userUID()
                let profileImageRef = self.storage.reference().child("users/\(userUID)/profileImage.jpg")
                
                profileImageRef.putFile(from: imageURL, metadata: nil) { _, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    
                    profileImageRef.downloadURL { url, error in
                        if let error = error {
                            single(.failure(error))
                        } else if let url = url {
                            single(.success(url))
                        } else {
                            single(.failure(UserStateError.missingURL))
                        }
                    }
                }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
