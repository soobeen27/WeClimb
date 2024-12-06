//
//  LoginRepositoryImpl.swift
//  WeClimb
//
//  Created by 강유정 on 12/5/24.
//

import Foundation

struct LoginRepositoryImpl: LoginRepository {
    private let loginTypeDataSource: LoginTypeDataSource
    
    init(loginTypeDataSource: LoginTypeDataSource) {
        self.loginTypeDataSource = loginTypeDataSource
    }
    
    func getLoginType() -> LoginType {
        guard let user = loginTypeDataSource.currentUser else {
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
