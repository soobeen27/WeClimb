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
import FirebaseFirestore
import GoogleSignIn
import CryptoKit
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


class LoginVC: UIViewController {
    
    private lazy var viewModel: LoginVM = {
        return LoginVM()
    }()
    
    private let disposeBag = DisposeBag()
    private let tabBarVC = TabBarController()
    
    private let logo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "LogoText")
        return image
    }()
    
    private let kakaoLoginButton: UIButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: "Kakao_Login_Button") {
            button.setBackgroundImage(buttonImage, for: .normal)
        }
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: "Apple_Login_Button") {
            button.setBackgroundImage(buttonImage, for: .normal)
        }
        return button
    }()
    
    private let googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: "Google_Login_Button") {
            button.setBackgroundImage(buttonImage, for: .normal)
        }
        return button
    }()
    
    private let guestLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("비회원으로 둘러보기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    // MARK: - 버튼 이벤트
    func googleLoginButtonBind() {
        googleLoginButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            self.viewModel.googleLogin(presenter: self) { credential in
                self.viewModel.logIn(with: credential, loginType: .google) { result in
                    switch result {
                    case .login:
                        print("success")
                        self.navigationController?.pushViewController(self.tabBarVC, animated: true)
                        self.navigationController?.setNavigationBarHidden(true, animated: true)
                    case .createAccount:
                        // 회원가입 페이지 푸시
                        let signUpVC = PrivacyPolicyVC()
                        self.navigationController?.pushViewController(signUpVC, animated: true)
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                    }
                }
            }
        }
        .disposed(by: disposeBag)
    }
    
    func kakaoLoginButtonBind() {
        kakaoLoginButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            self.viewModel.kakaoLogin { credential in
                self.viewModel.logIn(with: credential, loginType: .kakao) { result in
                    switch result {
                    case .login:
                        print("success")
                        self.navigationController?.pushViewController(self.tabBarVC, animated: true)
                        self.navigationController?.setNavigationBarHidden(true, animated: true)
                    case .createAccount:
                        //회원가입 페이지 ㄱㄱ
                        let signUpVC = PrivacyPolicyVC()
                        self.navigationController?.pushViewController(signUpVC, animated: true)
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                    }
                }
            }
            
        }
        .disposed(by: disposeBag)
    }
    
    func appleLoginButtonBind() {
        appleLoginButton.rx.tap.bind { [weak self] in
            guard let self else { return }
            self.viewModel.appleLogin(delegate: self, provider: self)
        }
        .disposed(by: disposeBag)
    }
    
    func loginButtonBind() {
        googleLoginButtonBind()
        kakaoLoginButtonBind()
        appleLoginButtonBind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        
//        autoLoginCheck()
        loginButtonBind()
        setLayout()
        buttonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //로그인 창으로 돌아왔을때 네비게이션 바 보이기
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func buttonTapped() {
        guestLoginButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                print("비회원 로그인 성공")
                //탭바로 넘어갈 때 네비게이션바 가리기
                let tabBarVC = TabBarController()
                self.navigationController?.pushViewController(tabBarVC, animated: true)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        [logo, buttonStackView]
            .forEach {
                view.addSubview($0)
            }
        [kakaoLoginButton, appleLoginButton, googleLoginButton, guestLoginButton]
            .forEach {
                buttonStackView.addArrangedSubview($0)
            }
        logo.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 160, height: 30))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(140)
        }
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
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
    
    // 자동 로그인 체크
//    private func autoLoginCheck() {
//        // Firebase Auth의 현재 사용자 확인
//        if let currentUser = Auth.auth().currentUser {
//            // 사용자가 로그인되어 있는 경우 메인 화면으로 이동
//            print("User already logged in with UID: \(currentUser.uid), navigating to main feed.")
//            navigateToMainFeedVC()
//        } else {
//            print("No user is currently logged in, displaying login screen.")
//        }
//    }
    func navigateToMainFeedVC() {
        let tabBarController = TabBarController()
        navigationController?.pushViewController(tabBarController, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
            guard let nonce = viewModel.currentNonce else {
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
            viewModel.logIn(with: credential, loginType: .apple) { result in
                switch result {
                case .login:
                    print("success")
                    self.navigationController?.pushViewController(self.tabBarVC, animated: true)
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                case .createAccount:
                    //회원가입 페이지 ㄱㄱ
                    let signUpVC = PrivacyPolicyVC()
                    self.navigationController?.pushViewController(signUpVC, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }
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
