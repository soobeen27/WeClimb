//
//  UserUpdateDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/27/24.
//

import Foundation
import RxSwift
import Firebase
import FirebaseStorage

protocol UserUpdateDataSource {
    func updateUser(with data: String, for field: String, userRef: DocumentReference) -> Single<Void>
    func uploadProfileImage(image: URL) -> Observable<URL>
}

class DefaultUserUpdateDataSource {

    func updateUser(with data: String, for field: String, userRef: DocumentReference) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
                userRef.updateData([field : data]) { error in
                    if let error {
                        single(.failure(error))
                        return
                    }
                    single(.success(()))
                }
            return Disposables.create()
        }
    }
    
    func uploadProfileImage(image: URL) -> Observable<URL> {
        return Observable<URL>.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            do {
                let uid = try FirestoreHelper.userUID()
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let profileImageRef = storageRef.child("users/\(uid)/profileImage.jpg")
                
                profileImageRef.putFile(from: image, metadata: nil) { metaData, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    profileImageRef.downloadURL { url, error in
                        if let error = error {
                            observer.onError(error)
                            return
                        }
                        guard let url else {
                            observer.onError(NetworkError.dataNil)
                            return
                        }
                        observer.onNext(url)
                    }
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
