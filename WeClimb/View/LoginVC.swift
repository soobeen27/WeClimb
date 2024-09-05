//
//  LoginVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import CryptoKit
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


class LoginVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    fileprivate var currentNonce: String?
    
    private let loginTitleLabel = {
        let label = UILabel()
        label.text = "We climb, 위클"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .mainPurple
        
        return label
    }()
    
    private let kakaoLoginButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: "Kakao_Login_Button") {
            button.setBackgroundImage(buttonImage, for: .normal)
            button.addTarget(self, action: #selector(kakaoLoginTapped), for: .touchUpInside)
        }
        return button
    }()
    
    private let appleLoginButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: "Apple_Login_Button") {
            button.setBackgroundImage(buttonImage, for: .normal)
            button.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        }
        return button
    }()
    
    private let googleLoginButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: "Google_Login_Button") {
            button.setBackgroundImage(buttonImage, for: .normal)
            button.addTarget(self, action: #selector(googleLoginTapped), for: .touchUpInside)
        }
        return button
    }()
    
    private let guestLoginButton = {
        let button = UIButton()
        button.setTitle("비회원으로 둘러보기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    private let buttonStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    // MARK: - 버튼 이벤트
    @objc func googleLoginTapped() {
        startGoogleLoginFlow()
    }
    
    @objc func kakaoLoginTapped() {
        startKakaoFirebaseLoginFlow()
    }
    
    @objc func appleLoginTapped() {
        startSignInWithAppleFlow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        
        setLayout()
        buttonTapped()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //로그인 창으로 돌아왔을때 네비게이션 바 보이기
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func buttonTapped() {
        guestLoginButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.pushViewController(TabBarController(), animated: true)
                print("비회원 로그인 성공")
                //탭바로 넘어갈 때 네비게이션바 가리기
                self?.navigationController?.setNavigationBarHidden(true, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        [loginTitleLabel, buttonStackView]
            .forEach {
                view.addSubview($0)
            }
        [kakaoLoginButton, appleLoginButton, googleLoginButton, guestLoginButton]
            .forEach {
                buttonStackView.addArrangedSubview($0)
            }
        loginTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        kakaoLoginButton.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.width.equalTo(300)
        }
        googleLoginButton.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.width.equalTo(300)
        }
        appleLoginButton.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.width.equalTo(300)
        }
    }
}

//MARK: - 구글 로그인
extension LoginVC {
    func startGoogleLoginFlow(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                // ...
                print(#fileID, #function, #line, "- comment")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                print(#fileID, #function, #line, "- comment")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // ...
            
            Auth.auth().signIn(with: credential) { result, error in
                
                // At this point, our user is signed in
            }
        }
    }
}

//MARK: - 애플 로그인
extension LoginVC {
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
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


extension LoginVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                print(#fileID, #function, #line, "- 애플 로그인 성공")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}

//MARK: - 카카오 로그인
extension LoginVC {
    func startKakaoFirebaseLoginFlow(){
        print(#fileID, #function, #line, "-")
        fetchKakaoOpenIDToken(completion: { idToken in
            guard let idToken = idToken else { return }
            
            let credential = OAuthProvider.credential(
                withProviderID: "oidc.kakao",  // As registered in Firebase console.
                idToken: idToken,  // ID token from OpenID Connect flow.
                // 파이어베이스 문서에서 rawNonce: nil로 써있지만 rawNonce가 String이라 nil이 안된다고 오류가 떠서 ""로 임시 조치함
                rawNonce: ""
            )
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil {
                    // Handle error.
                    print(#fileID, #function, #line, "- 에러 \(error)")
                    return
                }
                // User is signed in.
                // IdP data available in authResult?.additionalUserInfo?.profile
                print(#fileID, #function, #line, "- 카카오 로그인 성공")
            }
        })
    }
    
    // 카카오 로그인 하고 OpenID 토큰 가져오기
    func fetchKakaoOpenIDToken(completion: @escaping (String?) -> Void){
        // 카카오톡이 설치되어 있다면
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
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
                    
                    //do something
                    _ = oauthToken
                    completion(oauthToken?.idToken)
                }
            }
        }
    }
}
