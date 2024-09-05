//
//  User.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/5/24.
//

import Foundation

struct User: Codable {
    let authToken: String
    let lastModified: Date
    let loginType: String
    let registrationDate: Date
    let userName: String
    let userRole: String
}
