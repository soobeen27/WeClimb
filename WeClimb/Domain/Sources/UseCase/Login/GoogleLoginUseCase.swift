//
//  GoogleUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/5/24.
//

import Foundation

import RxSwift

protocol GoogleLoginUseCase {
    func execute(presentProvider: @escaping PresenterProvider) -> Single<LoginResult>
}

struct GoogleUseCaseImpl {
    private let googleLoginRepository: GoogleLoginRepository
    
    init(googleLoginRepository: GoogleLoginRepository) {
        self.googleLoginRepository = googleLoginRepository
    }
    
    func execute(presentProvider: @escaping PresenterProvider) -> Single<LoginResult> {
        return googleLoginRepository.googleLogin(presentProvider: presentProvider)
    }
}
