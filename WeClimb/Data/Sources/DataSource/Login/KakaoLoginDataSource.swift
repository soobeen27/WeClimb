//
//  KakaoLogin.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/3/24.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import RxSwift
import FirebaseAuth

protocol KakaoLoginDataSource {
    func kakaoLogin() -> Single<AuthCredential>
}

class KakaoLoginDataSourceImpl: KakaoLoginDataSource {
    private let disposeBag = DisposeBag()
    //MARK: 카카오 로그인
    func kakaoLogin() -> Single<AuthCredential> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CommonError.selfNil))
                return Disposables.create()
            }
            fetchKakaoOpenIDToken()
                .subscribe(onSuccess: { idToken in
                    guard let idToken else {
                        single(.failure(LoginError.invalidIDToken))
                        return
                    }
                    let credential = OAuthProvider.credential(providerID: .custom("oidc.kakao"), idToken: idToken, rawNonce: "", accessToken: nil)
                    single(.success(credential))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func fetchKakaoOpenIDToken() -> Single<String?> {
        return Single.create { single in
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error {
                        single(.failure(error))
                    }
                    else {
                        single(.success(oauthToken?.idToken))
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error {
                        single(.failure(error))
                    }
                    else {
                        single(.success(oauthToken?.idToken))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
