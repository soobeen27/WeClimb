//
//  LoginAssembly.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Swinject

final class LoginAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(AppleLoginDataSource.self) { _ in
            AppleLoginDataSourceImpl()
        }
        container.register(GoogleLoginDataSource.self) { _ in
            GoogleLoginDataSourceImpl()
        }
        container.register(KakaoLoginDataSource.self) { _ in
            KakaoLoginDataSourceImpl()
        }
        container.register(LoginFirebaseDataSource.self) { _ in
            LoginFirebaseDataSourceImpl()
        }
        
        container.register(OnboardingBuilder.self) { resolver in
            OnboardingBuilderImpl()
        }
        
        container.register(AppleLoginRepository.self) { resolver in
            AppleLoginRepositoryImpl(
                appleLoginDataSource: resolver.resolve(AppleLoginDataSource.self)!,
                loginFirebaseDataSource: resolver.resolve(LoginFirebaseDataSource.self)!
            )
        }
        
        container.register(GoogleLoginRepository.self) { resolver in
            GoogleLoginRepositoryImpl(
                googleLoginDataSource: resolver.resolve(GoogleLoginDataSource.self)!,
                loginFirebaseDataSource: resolver.resolve(LoginFirebaseDataSource.self)!
            )
        }
        
        container.register(KakaoLoginRepository.self) { resolver in
            KakaoLoginRepositoryImpl(
                kakaoLoginDataSource: resolver.resolve(KakaoLoginDataSource.self)!,
                loginFirebaseDataSource: resolver.resolve(LoginFirebaseDataSource.self)!
            )
        }
        
        container.register(AppleLoginUseCase.self) { resolver in
            AppleLoginUseCaseImpl(
                appleLoginRepository: resolver.resolve(AppleLoginRepository.self)!
            )
        }
        
        container.register(GoogleLoginUseCase.self) { resolver in
            GoogleUseCaseImpl(
                googleLoginRepository: resolver.resolve(GoogleLoginRepository.self)!
            )
        }
        
        container.register(KakaoLoginUseCase.self) { resolver in
            KakaoLoginUseCaseImpl(
                kakaoLoginRepository: resolver.resolve(KakaoLoginRepository.self)!
            )
        }
        
        container.register(LoginUseCase.self) { resolver in
            LoginUseCaseImpl(
                appleLoginUseCase: resolver.resolve(AppleLoginUseCase.self)!,
                googleLoginUseCase: resolver.resolve(GoogleLoginUseCase.self)!,
                kakaoLoginUseCase: resolver.resolve(KakaoLoginUseCase.self)!
            )
        }
        
        container.register(LoginVM.self) { resolver in
            LoginImpl(usecase: resolver.resolve(LoginUseCase.self)!)
        }
        
        container.register(PrivacyPolicyVM.self) { resolver in
            PrivacyPolicyImpl(usecase: resolver.resolve(SNSAgreeUsecase.self)!)
        }
        
        container.register(CreateNicknameVM.self) { resolver in
            CreateNicknameImpl(
                checkDuplicationUseCase: resolver.resolve(NicknameDuplicationCheckUseCase.self)!,
                registerNicknameUseCase: resolver.resolve(NicknameRegisterUseCase.self)!
            )
        }
    }
}
