//
//  KakaoLoginUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/5/24.
//
import Foundation

import RxSwift

protocol KakaoLoginUseCase {
    func execute() -> Single<LoginResult>
}

struct KakaoLoginUseCaseImpl: KakaoLoginUseCase {
    private let kakaoLoginRepository: KakaoLoginRepository
    
    init(kakaoLoginRepository: KakaoLoginRepository) {
        self.kakaoLoginRepository = kakaoLoginRepository
    }

    func execute() -> Single<LoginResult> {
        return kakaoLoginRepository.kakaoLogin()
    }
}
