//
//  KakaoLoginRepositoryImpl.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/4/24.
//

import Foundation

import RxSwift

class KakaoLoginRepositoryImpl: KakaoLoginRepository {
    private let kakaoLoginDataSource: KakaoLoginDataSource
    private let loginFirebaseDataSource: LoginFirebaseDataSource
    
    init(kakaoLoginDataSource: KakaoLoginDataSource, 
         loginFirebaseDataSource: LoginFirebaseDataSource)
    {
        self.kakaoLoginDataSource = kakaoLoginDataSource
        self.loginFirebaseDataSource = loginFirebaseDataSource
    }
    
    func kakaoLogin() -> Single<LoginResult> {
        kakaoLoginDataSource.kakaoLogin()
            .flatMap { [weak self] credential in
                guard let self else { return .error(CommonError.selfNil) }
                return self.loginFirebaseDataSource.logIn(with: credential, loginType: .kakao)
            }
    }
}
