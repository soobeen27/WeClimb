//
//  AppleLoginUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/5/24.
//

import Foundation

import RxSwift

protocol AppleLoginUseCase {
    func execute() -> Single<LoginResult>
}

struct AppleLoginUseCaseImpl: AppleLoginUseCase {
    private let appleLoginRepository: AppleLoginRepository
    
    init(appleLoginRepository: AppleLoginRepository) {
        self.appleLoginRepository = appleLoginRepository
    }
    
    func execute() -> Single<LoginResult> {
        return appleLoginRepository.appleLogin()
    }
}
