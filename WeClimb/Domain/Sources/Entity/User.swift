//
//  User.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/5/24.
//

import Foundation
import FirebaseFirestore

struct User: Codable {
    let userName: String?
    let profileImage: String?
    let registerationDate: Date
    let lastModified: Date
    let userRole: String
    let armReach: Int?
    let height: Int?
    let posts: [DocumentReference]?
    let comments: [DocumentReference]?
    let followers: [String]?
    let following: [String]?
    let snsConsent: Bool?
    var blackList: [String]?
}

enum UserUpdate: String {
    case userName
    case armReach
    case profileImage
    case height
    case snsConsent
    
    var key: String {
        switch self {
        case .userName:
            return "userName"
        case .armReach:
            return "armReach"
        case .profileImage:
            return "profileImage"
        case .height:
            return "height"
        case .snsConsent:
            return "snsConsent"
        }
    }
}

extension User {
    static let erroredUser = User(userName: "정보를 불러오지 못함", profileImage: nil, registerationDate: Date(), lastModified: Date(), userRole: "user", armReach: nil, height: nil, posts: nil, comments: nil, followers: nil, following: nil, snsConsent: false)
}
