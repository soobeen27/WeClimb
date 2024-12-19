//
//  LoginVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit

class LoginVC: UIViewController {
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Login.loginLogo)
        return image
    }()
    
    private let kakaoLoginButton: UIButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: Login.kakaoLoginButton) {
            button.setBackgroundImage(buttonImage, for: .normal)
        }
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: Login.appleLoginButton) {
            button.setBackgroundImage(buttonImage, for: .normal)
        }
        return button
    }()
    
    private let googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: Login.googleLoginButton) {
            button.setBackgroundImage(buttonImage, for: .normal)
        }
        return button
    }()
    
    private let guestLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Login.nonMemberButton, for: .normal)
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
            $0.size.equalTo(CGSize(width: 135, height: 169))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(48)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().multipliedBy(0.85)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(343)
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(343)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(343)
        }
    }
}
