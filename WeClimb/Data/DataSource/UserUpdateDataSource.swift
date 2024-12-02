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
    func updateUser<T>(with data: T, for field: UserUpdate, userRef: DocumentReference) -> Completable
    func uploadProfileImageToStorage(imageURL: URL, userUID: String) -> Single<URL>
}

final class UserUpdateDataSourceImpl: UserUpdateDataSource {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func updateUser<T>(with data: T, for field: UserUpdate, userRef: DocumentReference) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create() }
            
            userRef.updateData([field : data]) { error in
                if let error {
                    completable(.error(error))
                    return
                }
                completable(.completed)
            }
            return Disposables.create()
        }
    }
    
    func uploadProfileImageToStorage(imageURL: URL, userUID: String) -> Single<URL> {
        return Single<URL>.create { single in
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
                        single(.failure(UserUpdateError.missingURL))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}

enum UserUpdateError: Error {
    case notAuthenticated
    case missingURL
    
    var localizedDescription: String {
        switch self {
        case .notAuthenticated:
            return "사용자가 인증되지 않았습니다."
        case .missingURL:
            return "업로드된 이미지의 URL을 가져오지 못했습니다."
        }
    }
}

/*
  유즈케이스에 프로필이미지 구현부분
 func uploadAndUpdateProfileImage(imageURL: URL, userUID: String) -> Completable {
     return uploadProfileImageToStorage(imageURL: imageURL, userUID: userUID)
         .flatMapCompletable { url in
             let userRef = Firestore.firestore().collection("users").document(userUID)
             return self.updateUser(with: url.absoluteString, for: .profileImage, userRef: userRef)
         }
 }
 */
