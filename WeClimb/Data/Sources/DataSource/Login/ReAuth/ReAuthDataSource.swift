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
                completable(.error(UserStateError.nonmember))
                return Disposables.create()
            }
//            print("유저 정보: \(user.uid)")
            user.reauthenticate(with: credential) { result, error in
                if let error = error {
//                    print("에러발생")
                    return completable(.error(error))
                }
                completable(.completed)
//                print("재인증 성공")
            }
            return Disposables.create()
        }
    }
}
