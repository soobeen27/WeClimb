//
//  SNSAuth.swift
//  WeClimb
//
//  Created by Soobeen Jang on 10/21/24.
//

import AuthenticationServices
import Foundation

import CryptoKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class SNSAuthVM {
    
    var currentNonce: String?

    func reAuthenticate(with credential: AuthCredential, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                completion(error)
                return
            }
            print("ReAurhentication Succeed!")
            completion(nil)
        }
    }
    
    //MARK: 구글 로그인
    func googleLogin(presenter: UIViewController, completion: @escaping (AuthCredential) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presenter) { result, error in
            guard error == nil else {
                print(#fileID, #function, #line, "- comment")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print(#fileID, #function, #line, "- comment")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            completion(credential)
        }
    }
    
    func kakaoLogin(completion: @escaping (AuthCredential) -> Void) {
        fetchKakaoOpenIDToken() { idToken in
            guard let idToken = idToken else { return }
            
            let credential = OAuthProvider.credential(
                withProviderID: "oidc.kakao",  // As registered in Firebase console.
                idToken: idToken,  // ID token from OpenID Connect flow.
                // 파이어베이스 문서에서 rawNonce: nil로 써있지만 rawNonce가 String이라 nil이 안된다고 오류가 떠서 ""로 임시 조치함
                rawNonce: ""
            )
            completion(credential)
        }
    }
    
    func fetchKakaoOpenIDToken(completion: @escaping (String?) -> Void) {
        // 카카오톡이 설치되어 있다면
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    completion(oauthToken?.idToken)
                }
            }
        } else {
            // 웹 브라우저로 로그인 시도
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    completion(oauthToken?.idToken)
                }
            }
        }
    }
    
    func appleLogin(delegate: ASAuthorizationControllerDelegate, provider: ASAuthorizationControllerPresentationContextProviding) {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = delegate
        authorizationController.presentationContextProvider = provider
        authorizationController.performRequests()
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
            // Pick a random character from the set, wrapping around if needed.
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
