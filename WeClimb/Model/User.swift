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
