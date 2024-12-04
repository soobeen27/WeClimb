
//
//  AppleLoginDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/3/24.
//

import Foundation
import FirebaseAuth
import RxSwift
import AuthenticationServices
import CryptoKit

protocol AppleLoginDataSource {
    var currentNonce: String? { get set }
    func appleLogin() -> Single<AuthCredential>
}

class AppleLoginDataSourceImpl: AppleLoginDataSource {
    
    var currentNonce: String?
    
    func appleLogin() -> Single<AuthCredential> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CommonError.selfNil))
                return Disposables.create()
            }
            
            let request = appleLoginRequest()
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.performRequests()
            
            let delegate = AppleLoginDelegate { result in
                switch result {
                case .success(let credential):
                    single(.success(credential))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            controller.delegate = delegate
            controller.presentationContextProvider = delegate
            
            return Disposables.create()
        }
    }
    
    private func appleLoginRequest() -> ASAuthorizationAppleIDRequest {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        return request
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
