//
//  LoginAssembly.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Swinject

final class LoginAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ReAuthDataSource.self) { _ in
            ReAuthDataSourceImpl()
        }
        container.register(AppleLoginDataSource.self) { _ in
            AppleLoginDataSourceImpl()
        }
        container.register(GoogleLoginDataSource.self) { _ in
            GoogleLoginDataSourceImpl()
        }
        container.register(KakaoLoginDataSource.self) { _ in
            KakaoLoginDataSourceImpl()
        }
        
        container.register(ReAuthRepository.self) { resolver in
            ReAuthRepositoryImpl(
                reAuthDataSource: resolver.resolve(ReAuthDataSource.self)!,
                appleLoginDataSource: resolver.resolve(AppleLoginDataSource.self)!,
                googleLoginDataSource: resolver.resolve(GoogleLoginDataSource.self)!,
                kakaoLoginDataSource: resolver.resolve(KakaoLoginDataSource.self)!
            )
        }
        container.register(ReAuthUseCase.self) { resolver in
            ReAuthUseCaseImpl(
                reAuthRepository: resolver.resolve(ReAuthRepository.self)!
            )
        }
        
        container.register(LoginVM.self) { resolver in
            LoginVM(
                usecase: resolver.resolve(ReAuthUseCase.self)!
            )
        }
    }
}
