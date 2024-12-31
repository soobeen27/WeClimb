//
//  LoginVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class LoginVC: UIViewController {
    var coordinator: LoginCoordinator?
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = OnboardingConst.Login.Image.weclimbLogo
        return image
    }()
    
    private let kakaoLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(OnboardingConst.Login.Image.kakaoLoginButton, for: .normal)
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(OnboardingConst.Login.Image.appleLoginButton, for: .normal)
        return button
    }()
    
    private let googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(OnboardingConst.Login.Image.googleLoginButton, for: .normal)
        return button
    }()
    
    private let guestLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle(OnboardingConst.Login.Text.nonMemberButton, for: .normal)
        button.setTitleColor(OnboardingConst.Login.Color.guestLoginFontColor, for: .normal)
        button.titleLabel?.font = OnboardingConst.Login.Font.guestLogin
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = OnboardingConst.Login.Spacing.vertical
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.white
        
        [
            logoImage,
            buttonStackView
        ].forEach { view.addSubview($0) }
        
        [
            kakaoLoginButton,
            appleLoginButton,
            googleLoginButton,
            guestLoginButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
        
        logoImage.snp.makeConstraints {
            $0.size.equalTo(OnboardingConst.Login.Size.weclimbLogo)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OnboardingConst.Login.Spacing.logoTopMargin)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().multipliedBy(OnboardingConst.Login.Spacing.BottomOffset)
            $0.leading.equalToSuperview().offset(OnboardingConst.Login.Spacing.padding)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.Login.Spacing.padding)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.height.width.equalTo(OnboardingConst.Login.Size.loginButton)
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.height.width.equalTo(OnboardingConst.Login.Size.loginButton)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.height.width.equalTo(OnboardingConst.Login.Size.loginButton)
        }
    }
}
