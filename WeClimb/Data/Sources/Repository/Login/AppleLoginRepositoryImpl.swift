//
//  AppleLoginRepositoryImpl.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/4/24.
//

import Foundation
import RxSwift

class AppleLoginRepositoryImpl {
    let appleLoginDataSource: AppleLoginDataSource
    let loginFirebaseDataSource: LoginFirebaseDataSource
    
    init(appleLoginDataSource: AppleLoginDataSource, loginFirebaseDataSource: LoginFirebaseDataSource) {
        self.appleLoginDataSource = appleLoginDataSource
        self.loginFirebaseDataSource = loginFirebaseDataSource
    }
    
    func appleLogin() -> Single<LoginResult> {
        appleLoginDataSource.appleLogin()
            .flatMap { [weak self] credential in
                guard let self else { return .error(CommonError.selfNil) }
                return self.loginFirebaseDataSource.logIn(with: credential, loginType: .apple)
            }
    }
}
