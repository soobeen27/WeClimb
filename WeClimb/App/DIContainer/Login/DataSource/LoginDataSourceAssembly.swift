//
//  LoginDataSourceAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class LoginDataSourceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppleLoginDataSource.self) { _ in
            AppleLoginDataSourceImpl()
        }
        container.register(GoogleLoginDataSource.self) { _ in
            GoogleLoginDataSourceImpl()
        }
        container.register(ReAuthDataSource.self) { _ in
            ReAuthDataSourceImpl()
        }
        container.register(CurrentUserDataSource.self) { _ in
            currentUserDataSourceImpl()
        }
        container.register(KakaoLoginDataSource.self) { _ in
            KakaoLoginDataSourceImpl()
        }
        container.register(LoginFirebaseDataSource.self) { _ in
            LoginFirebaseDataSourceImpl()
        }
    }
}
