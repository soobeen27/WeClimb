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
    let armReach: String?
    let height: String?
    let posts: [DocumentReference]?
    let comments: [DocumentReference]?
    let followers: [DocumentReference]?
    let following: [DocumentReference]?
    let blackList: [String]?
}

