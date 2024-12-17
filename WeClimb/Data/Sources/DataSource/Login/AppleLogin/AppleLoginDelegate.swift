//
//  AppleLoginDelegate.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/3/24.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

final class AppleLoginDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private let completion: (Result<AuthCredential, Error>) -> Void
    private let nonce: String

    init(nonce: String, completion: @escaping (Result<AuthCredential, Error>) -> Void) {
        self.completion = completion
        self.nonce = nonce
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityToken = appleIDCredential.identityToken,
           let tokenString = String(data: identityToken, encoding: .utf8) {
            let credential = OAuthProvider.credential(providerID: .apple, idToken: tokenString, rawNonce: nonce)
            completion(.success(credential))
        } else {
            completion(.failure(LoginError.invaildCredention))
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion(.failure(error))
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            fatalError("Unable to find a valid presentation anchor.")
        }
        return window
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}


