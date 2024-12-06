//
//  LoginTypeDataSource.swift
//  WeClimb
//
//  Created by 강유정 on 12/5/24.
//

import FirebaseAuth

protocol LoginTypeDataSource {
    var currentUser: FirebaseAuth.User? { get }
}

final class LoginTypeDataSourceImpl: LoginTypeDataSource {
    private let auth = Auth.auth()
    
    var currentUser: FirebaseAuth.User? {
        return auth.currentUser
    }
}
