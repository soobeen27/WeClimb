//
//  GoogleLoginRepository.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/3/24.
//

import Foundation

import RxSwift

class GoogleLoginRepositoryImpl: GoogleLoginRepository {
    private let googleLoginDataSource: GoogleLoginDataSource
    private let loginFirebaseDataSource: LoginFirebaseDataSource
    
    init(googleLoginDataSource: GoogleLoginDataSource, 
         loginFirebaseDataSource: LoginFirebaseDataSource)
    {
        self.googleLoginDataSource = googleLoginDataSource
        self.loginFirebaseDataSource = loginFirebaseDataSource
    }
    
    func googleLogin(presentProvider: @escaping PresenterProvider) -> Single<LoginResult> {
        return googleLoginDataSource
            .googleLogin(presenterProvider: presentProvider)
            .flatMap { [weak self] credential in
                guard let self else { return .error(CommonError.selfNil) }
                return self.loginFirebaseDataSource.logIn(with: credential, loginType: .google)
            }
    }
}
