//
//  FirebaseManager.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/5/24.
//

import UIKit

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import CryptoKit
import AuthenticationServices

final class FirebaseManager {
    
    private let db = Firestore.firestore()
    
    static let shared = FirebaseManager()
    private init() {}
        
    func updateAccount(with data: String, for field: UserUpdate, completion:  @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let userRef = db.collection("users").document(user.uid)
        
        userRef.updateData([field.key : data]) { error in
            if let error = error {
                print("업데이트 에러!: \(error.localizedDescription)")
                return
            }
            completion()
        }
    }
}
