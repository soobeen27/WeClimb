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
    case noName
    case createAccount
}

//enum UserUpdate {
//    case userName
//    case height
//    case armReach
//    case profileImage
//    
//    var key: String {
//        switch self {
//        case .userName:
//            return "userName"
//        case .height:
//            return "height"
//        case .armReach:
//            return "armReach"
//        case .profileImage:
//            return "profileImage"
//        }
//    }
//}

enum LoginType {
    case google
    case apple
    case kakao
    case none
    
    var string: String {
        switch self {
        case .google:
            return "google"
        case .apple:
            return "apple"
        case .kakao:
            return "kakao"
        case .none:
            return "undefined"
        }
    }
}

enum Like {
    case post
    case comment
    
    var string: String {
        switch self {
        case .post:
            return "posts"
        case .comment:
            return "comments"
        }
    }
}

//MARK: 유저 관련 에러
enum UserError: Error {
    case none
    case logout
    case noID
    
    var description: String {
        switch self {
        case .none:
            "해당 이름 유저 없음"
        case .logout:
            "로그인된 유저가 없음"
        case .noID:
            "로그인된 아이디를 찾을 수 없음"
        }
    }
}

//MARK: Post 관련에러
enum PostError: Error {
    case none
    case mapping
    
    var description: String {
        switch self {
        case .none:
            "아무런 포스트가 없음"
        case .mapping:
            "매핑중 오류"
        }
    }
}

enum UploadStatus {
    case fail
    case success
}

enum GetDocumentError: Error {
    case noField
    case failDecoding
}

// MARK: Feed Type
enum FeedType {
    case mainFeed
    case myPage
    case userPage
    case filterPage
}
