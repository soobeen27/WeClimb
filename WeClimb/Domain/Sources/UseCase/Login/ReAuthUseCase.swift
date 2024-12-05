//
//  ReAuthUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 12/2/24.
//

import RxSwift
import AuthenticationServices

protocol ReAuthUseCase {
    func execute(loginType: LoginType, presentProvider: PresenterProvider?) -> Completable
}

struct ReAuthUseCaseImpl: ReAuthUseCase {
    private let reAuthRepository: ReAuthRepository
    
    init(reAuthRepository: ReAuthRepository) {
        self.reAuthRepository = reAuthRepository
    }

    func execute(loginType: LoginType, presentProvider: PresenterProvider?) -> Completable {
        switch loginType {
        case .google:
            guard let presentProvider else { return .error(FuncError.wrongArgument)}
            return reAuthRepository.reAuthGoogle(presenterProvider: presentProvider)
        case .apple:
            return reAuthRepository.reAuthApple()
        case .kakao:
            return reAuthRepository.reAuthKakao()
        case .none:
            return .error(FuncError.unknown)
        }
    }
}

