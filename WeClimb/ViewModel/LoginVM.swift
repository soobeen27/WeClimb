//
//  LoginVM.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/4/24.
//

import Foundation

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import CryptoKit
import AuthenticationServices

class LoginVM {
    func createUser(user: FirebaseAuth.User, loginType: String, userInfo: User) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userInfo.userName)
        userRef.getDocument { (document, error) in
            guard let document = document,
                  document.exists
            else {
                do {
                    try db.collection("user").document(userInfo.userName).setData(from: userInfo)
                } catch {
                    print("Error: user, setData")
                }
                return
            }
        }
    }
}


