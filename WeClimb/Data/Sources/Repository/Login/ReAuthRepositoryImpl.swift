//
//  ReAuthRepositoryImpl.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/5/24.
//

import Foundation

import RxSwift

class ReAuthRepositoryImpl: ReAuthRepository {
    private let reAuthDataSource: ReAuthDataSource
    private let appleLoginDataSource: AppleLoginDataSource
    private let googleLoginDataSource: GoogleLoginDataSource
    private let kakaoLoginDataSource: KakaoLoginDataSource
    
    init(reAuthDataSource: ReAuthDataSource, appleLoginDataSource: AppleLoginDataSource, googleLoginDataSource: GoogleLoginDataSource, kakaoLoginDataSource: KakaoLoginDataSource) {
        self.reAuthDataSource = reAuthDataSource
        self.appleLoginDataSource = appleLoginDataSource
        self.googleLoginDataSource = googleLoginDataSource
        self.kakaoLoginDataSource = kakaoLoginDataSource
    }
    
    func reAuthApple() -> Completable {
        appleLoginDataSource.appleLogin()
            .flatMapCompletable { [weak self] credential in
                guard let self else { return .error(CommonError.selfNil) }
                return self.reAuthDataSource.reAuthenticate(with: credential)
            }
    }
    
    func reAuthGoogle(presenterProvider: @escaping PresenterProvider) -> Completable {
        googleLoginDataSource.googleLogin(presenterProvider: presenterProvider)
            .flatMapCompletable { [weak self] credential in
                guard let self else { return .error(CommonError.selfNil) }
                return self.reAuthDataSource.reAuthenticate(with: credential)
            }
    }
    
    func reAuthKakao() -> Completable {
        kakaoLoginDataSource.kakaoLogin()
            .flatMapCompletable { [weak self] credential in
                guard let self else { return .error(CommonError.selfNil) }
                return self.reAuthDataSource.reAuthenticate(with: credential)
            }
    }
}
