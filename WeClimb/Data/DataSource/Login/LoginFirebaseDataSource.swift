//
//  LoginFirebaseDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/3/24.
//

import Foundation

import RxSwift
import Firebase
import FirebaseAuth

protocol LoginFirebaseDataSource {
    func logIn(with credential: AuthCredential, loginType: LoginType) -> Single<LoginResult>
}

class LoginFirebaseDataSourceImpl: LoginFirebaseDataSource {
    private let db = Firestore.firestore()
    private let disposeBag = DisposeBag()
    
    func logIn(with credential: AuthCredential, loginType: LoginType) -> Single<LoginResult> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CommonError.selfNil))
                return Disposables.create()
            }
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error {
                    single(.failure(error))
                    return
                }
                self.getLoginResult(authResult: authResult)
                    .subscribe(onSuccess: { loginResult in
                        single(.success(loginResult))
                    }, onFailure: { error in
                        single(.failure(error))
                    })
                    .disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }
    
    private func getLoginResult(authResult: AuthDataResult?) -> Single<LoginResult> {
        return Single.create { [weak self] single in
            guard let self else { 
                single(.failure(CommonError.selfNil))
                return Disposables.create()
            }
            guard let authResult else {
                single(.failure(LoginError.wrongAuthResult))
                return Disposables.create()
            }
            let user = authResult.user
            let userRef = self.db.collection("users").document(user.uid)
            userRef.getDocument { [weak self] document, error in
                guard let self else {
                    single(.failure(CommonError.selfNil))
                    return
                }
                if let error {
                    single(.failure(error))
                    return
                }
                if let document, document.exists {
                    single(.success(self.userNameExist(document: document)))
                } else {
                    self.createUser(ref: userRef)
                        .subscribe(onSuccess: { loginResult in
                            single(.success(loginResult))
                        }, onFailure: { error in
                            single(.failure(error))
                        })
                        .disposed(by: self.disposeBag)
                }
            }
            return Disposables.create()
        }
    }
    
    private func userNameExist(document: DocumentSnapshot) -> LoginResult {
        if let userData = document.data(), let userName = userData["userName"] as? String {
            return userNameEmpty(name: userName)
        } else {
            return .noName
        }
    }
    
    private func userNameEmpty(name: String) -> LoginResult {
        if name.isEmpty {
            return .noName
        } else {
            return .login
        }
    }
    
    private func createUser(ref: DocumentReference) -> Single<LoginResult> {
        return Single.create { single in
            do {
                try ref.setData(from: User(userName: nil, profileImage: nil, registerationDate: Date(), lastModified: Date(), userRole: "user", armReach: nil, height: nil, posts: nil, comments: nil, followers: nil, following: nil, snsConsent: false, blackList: nil))
                single(.success(.createAccount))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
