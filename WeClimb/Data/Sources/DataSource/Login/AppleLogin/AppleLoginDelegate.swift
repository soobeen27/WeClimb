//
//  AppleLoginDelegate.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/3/24.
//

import Foundation
import FirebaseAuth
import AuthenticationServices

final class AppleLoginDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private let completion: (Result<AuthCredential, Error>) -> Void

    init(completion: @escaping (Result<AuthCredential, Error>) -> Void) {
        self.completion = completion
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityToken = appleIDCredential.identityToken,
           let tokenString = String(data: identityToken, encoding: .utf8) {
            let credential = OAuthProvider.credential(providerID: .apple, accessToken: tokenString)
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
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return ASPresentationAnchor(frame: .zero) }
        return window
    }
}
