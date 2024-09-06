//
//  User.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/5/24.
//

import Foundation

struct User: Codable {
    let idToken: String
    let lastModified: Date
    let loginType: String
    let registrationDate: Date
    let userName: String?
    let userRole: String
    let armReach: String?
    let height: String?
    let followers: [String]?
    let following: [String]?
    let profileImage: String?
}
