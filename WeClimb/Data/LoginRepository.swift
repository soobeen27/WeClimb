//
//  LoginRepository.swift
//  WeClimb
//
//  Created by 강유정 on 12/4/24.
//

import Foundation

public protocol LoginRepository {
    func getLoginType() -> LoginType
}

public struct LoginRepositoryImpl: LoginRepository {
    private let loginDataSource: LoginDataSource
    
    init(loginDataSource: LoginDataSource) {
        self.loginDataSource = loginDataSource
    }
    
    public func getLoginType() -> LoginType {
        guard let user = loginDataSource.currentUser else {
            return .none
        }
        
        let snsType = user.providerData.first.map { $0.providerID } ?? "unknown"
        
        switch snsType {
        case "google.com":
            return .google
        case "apple.com":
            return .apple
        case "oidc.kakao":
            return .kakao
        default:
            return .none
        }
    }
}
