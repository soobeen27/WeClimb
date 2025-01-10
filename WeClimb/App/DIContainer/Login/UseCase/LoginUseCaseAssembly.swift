//
//  LoginUseCaseAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//
import Swinject

final class LoginUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppleLoginUseCase.self) { resolver in
            AppleLoginUseCaseImpl(appleLoginRepository: resolver.resolve(AppleLoginRepository.self)!)
        }
        container.register(GoogleLoginUseCase.self) { resolver in
            GoogleUseCaseImpl(googleLoginRepository: resolver.resolve(GoogleLoginRepository.self)!)
        }
        container.register(KakaoLoginUseCase.self) { resolver in
            KakaoLoginUseCaseImpl(kakaoLoginRepository: resolver.resolve(KakaoLoginRepository.self)!)
        }
        container.register(LoginTypeUseCase.self) { resolver in
            LoginTypeUseCaseImpl(loginTypeRepository: resolver.resolve(LoginTypeRepository.self)!)
        }
        container.register(LoginUseCase.self) { resolver in
            LoginUseCaseImpl(appleLoginUseCase: resolver.resolve(AppleLoginUseCase.self)!, googleLoginUseCase: resolver.resolve(GoogleLoginUseCase.self)!, kakaoLoginUseCase: resolver.resolve(KakaoLoginUseCase.self)!
            )
        }
        container.register(ReAuthUseCase.self) { resolver in
            ReAuthUseCaseImpl(reAuthRepository: resolver.resolve(ReAuthRepository.self)!
            )
        }
    }
}
