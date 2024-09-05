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


enum LoginError: Error {
    case noUser
    case userExist
    case fromSetData
    
}

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private init() {}
    
    private let db = Firestore.firestore()
    
    // 유저가 존재하는지 체크 .failure시 유저없는것, success시 존재하는것
    func userExist(authToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let tokenRef = db.collection("userToken").document(authToken)
        tokenRef.getDocument { document, error in
            if let document = document, document.exists {
                completion(.success(()))
            } else {
                completion(.failure(LoginError.noUser))
            }
        }
    }
    
    // 회원가입 메소드
    func signUp(userInfo: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(userInfo.userName)
        
        userRef.getDocument { [weak self] document, error in
            if let document = document, document.exists {
                completion(.failure(LoginError.userExist))
            } else {
                do {
                    try self?.db.collection("users")
                        .document(userInfo.userName)
                        .setData(from: userInfo)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
