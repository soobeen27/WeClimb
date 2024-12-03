//
//  UserUpdateRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift
import Firebase

final class UserUpdateRepositoryImpl: UserUpdateRepository {
    private let userUpdateDataSource: UserUpdateDataSource
    
    init(userUpdateDataSource: UserUpdateDataSource) {
        self.userUpdateDataSource = userUpdateDataSource
    }
    
    func updateUser<T>(with data: T, for field: UserUpdate, userRef: DocumentReference) -> Completable {
        return userUpdateDataSource.updateUser(with: data, for: field, userRef: userRef)
    }
    
    func uploadProfileImageToStorage(imageURL: URL, userUID: String) -> Single<URL> {
        return userUpdateDataSource.uploadProfileImageToStorage(imageURL: imageURL, userUID: userUID)
    }
}
