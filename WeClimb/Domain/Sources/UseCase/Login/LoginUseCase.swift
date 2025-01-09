//
//  LoginUsecase.swift
//  WeClimb
//
//  Created by 윤대성 on 1/6/25.
//

import RxSwift

protocol LoginUseCase {
    func execute(loginType: LoginType, presentProvider: PresenterProvider?) -> Single<LoginResult>
}

struct LoginUseCaseImpl: LoginUseCase {
    private let appleLoginUseCase: AppleLoginUseCase
    private let googleLoginUseCase: GoogleLoginUseCase
    private let kakaoLoginUseCase: KakaoLoginUseCase
    
    init(appleLoginUseCase: AppleLoginUseCase,
         googleLoginUseCase: GoogleLoginUseCase,
         kakaoLoginUseCase: KakaoLoginUseCase
    ) {
        self.appleLoginUseCase = appleLoginUseCase
        self.googleLoginUseCase = googleLoginUseCase
        self.kakaoLoginUseCase = kakaoLoginUseCase
    }
    
    func execute(loginType: LoginType, presentProvider: PresenterProvider?) -> Single<LoginResult> {
        switch loginType {
        case .apple:
            return appleLoginUseCase.execute()
        case .google:
            guard let presentProvider else { return .error(FuncError.wrongArgument)}
            return googleLoginUseCase.execute(presentProvider: presentProvider)
        case .kakao:
            return kakaoLoginUseCase.execute()
        case .none:
            return .error(AppError.unknown)
        }
    }
}
