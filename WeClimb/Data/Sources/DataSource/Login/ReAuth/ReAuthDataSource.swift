//
//  ReAuthDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/5/24.
//

import Foundation

import RxSwift
import FirebaseAuth

protocol ReAuthDataSource {
    func reAuthenticate(with credential: AuthCredential) -> Completable
}

class ReAuthDataSourceImpl: ReAuthDataSource {
    func reAuthenticate(with credential: AuthCredential) -> Completable {
        return Completable.create { completable in
            guard let user = Auth.auth().currentUser else {
                completable(.error(UserStateError.nonmeber))
                return Disposables.create()
            }
            user.reauthenticate(with: credential) { result, error in
                if let error = error {
                    return completable(.error(error))
                }
                completable(.completed)
            }
            return Disposables.create()
        }
    }
}
