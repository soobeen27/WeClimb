//
//  Enumeration.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/7/24.
//

import Foundation

//MARK: 로그인 관련 enum
enum LoginResult {
    case login
    case createAccount
}

enum UserUpdate {
    case userName
    case height
    case armReach
    
    var key: String {
        switch self {
        case .userName:
            return "userName"
        case .height:
            return "height"
        case .armReach:
            return "armReach"
        }
    }
}

enum LoginType {
    case google
    case apple
    case kakao
    
    var string: String {
        switch self {
        case .google:
            return "google"
        case .apple:
            return "apple"
        case .kakao:
            return "kakao"
        }
    }
}


//MARK: 유저 관련 에러
enum UserError: Error {
    case none
    
    var description: String {
        switch self {
        case .none:
            "해당 이름 유저 없음"
        }
    }
}
