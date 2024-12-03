//
//  GoogleLoginDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/3/24.
//

import Foundation
import GoogleSignIn
import RxSwift
import FirebaseAuth
import FirebaseCore

enum LoginError: Error {
    case invaildClientID
    case invalidResponse
    case invalidIDToken
    case invaildCredention
    case wrongAuthResult
}

protocol GoogleLoginDataSource {
    func googleLogin(presenterProvider: @escaping () -> UIViewController) -> Single<AuthCredential>
}

class GoogleLoginDataSourceImpl: GoogleLoginDataSource {
    func googleLogin(presenterProvider: @escaping () -> UIViewController) -> Single<AuthCredential> {
        return Single.create { single in
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                single(.failure(LoginError.invaildClientID))
                return Disposables.create()
            }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            let presenter = presenterProvider()
            
            GIDSignIn.sharedInstance.signIn(withPresenting: presenter) { result, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    single(.failure(LoginError.invalidResponse))
                    return
                }
                
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: user.accessToken.tokenString
                )
                single(.success(credential))
            }
            
            return Disposables.create()
        }
    }
}

