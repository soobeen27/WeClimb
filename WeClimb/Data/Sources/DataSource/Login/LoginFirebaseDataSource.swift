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
        return Single<AuthDataResult>.create { single in
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error {
                    single(.failure(error))
                    return
                }
                guard let authResult else {
                    single(.failure(LoginError.wrongAuthResult))
                    return
                }
                single(.success(authResult))
            }
            return Disposables.create()
        }.flatMap { [weak self] authResult in
            guard let self else { return Single.error(CommonError.selfNil)}
            return self.getLoginResult(authResult: authResult)
        }
    }
    
    private func getLoginResult(authResult: AuthDataResult) -> Single<LoginResult> {
        let user = authResult.user
        let userRef = self.db.collection("users").document(user.uid)
        return Single<DocumentSnapshot?>.create { single in
            userRef.getDocument { document, error in
                if let error {
                    single(.failure(error))
                    return
                }
                single(.success(document))
            }
            return Disposables.create()
        }
        .flatMap { [weak self] document in
            guard let self else { return .error(CommonError.selfNil)}
            if let document, document.exists {
                return .just(userNameExist(document: document))
            } else {
                return self.createUser(ref: userRef)
            }
            
        }
    }
    
    private func userNameExist(document: DocumentSnapshot) -> LoginResult {
        if let userName = document.data()?["userName"] as? String, !userName.isEmpty {
            return .login
        } else {
            return .noName
        }
    }
    
    private func createUser(ref: DocumentReference) -> Single<LoginResult> {
        return Single.create { single in
            do {
                try ref.setData(from: User(userName: nil, profileImage: nil,
                                           registerationDate: Date(), lastModified: Date(),
                                           userRole: "user", armReach: nil,
                                           height: 0, posts: nil,
                                           comments: nil, followers: nil,
                                           following: nil, snsConsent: false,
                                           blackList: nil)) 
                { error in
                    if let error {
                        single(.failure(error))
                        return
                    }
                    single(.success(.createAccount))
                }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
