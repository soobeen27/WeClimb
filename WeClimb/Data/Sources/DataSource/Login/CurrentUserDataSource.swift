//
//  LoginTypeDataSource.swift
//  WeClimb
//
//  Created by 강유정 on 12/5/24.
//

import FirebaseAuth

protocol CurrentUserDataSource {
    var currentUser: FirebaseAuth.User? { get }
}

final class currentUserDataSourceImpl: CurrentUserDataSource {
    private let auth = Auth.auth()
    
    var currentUser: FirebaseAuth.User? {
        return auth.currentUser
    }
}
