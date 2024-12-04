//
//  LoginDataSource.swift
//  WeClimb
//
//  Created by 강유정 on 12/4/24.
//

import FirebaseAuth

protocol LoginDataSource {
    var currentUser: FirebaseAuth.User? { get }
    func signOut() throws
}

final class LoginDataSourceImpl: LoginDataSource {
    private let auth = Auth.auth()
    
    var currentUser: FirebaseAuth.User? {
        return auth.currentUser
    }
    
    func signOut() throws {
        try auth.signOut()
    }
}
