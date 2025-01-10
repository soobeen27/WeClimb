//
//  LoginRepositoryAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class LoginRepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppleLoginRepository.self) { resolver in
            AppleLoginRepositoryImpl(appleLoginDataSource: resolver.resolve(AppleLoginDataSource.self)!, loginFirebaseDataSource: resolver.resolve(LoginFirebaseDataSource.self)!)
        }
        container.register(GoogleLoginRepository.self) { resolver in
            GoogleLoginRepositoryImpl(googleLoginDataSource: resolver.resolve(GoogleLoginDataSource.self)!,
                                      loginFirebaseDataSource: resolver.resolve(LoginFirebaseDataSource.self)!)
        }
        
        container.register(KakaoLoginRepository.self) { resolver in
            KakaoLoginRepositoryImpl(kakaoLoginDataSource: resolver.resolve(KakaoLoginDataSource.self)!, loginFirebaseDataSource: resolver.resolve(LoginFirebaseDataSource.self)!)
        }
        container.register(LoginTypeRepository.self) { resolver in
            LoginTypeRepositoryImpl(currentUserDataSource: resolver.resolve(CurrentUserDataSource.self)!)
        }
        
        container.register(ReAuthRepository.self) { resolver in
            ReAuthRepositoryImpl(reAuthDataSource: resolver.resolve(ReAuthDataSource.self)!,
                                 appleLoginDataSource: resolver.resolve(AppleLoginDataSource.self)!,
                                 googleLoginDataSource: resolver.resolve(GoogleLoginDataSource.self)!,
                                 kakaoLoginDataSource: resolver.resolve(KakaoLoginDataSource.self)!
            )
        }
    }
}
