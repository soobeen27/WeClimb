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

class LoginVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let loginTitleLabel = {
        let label = UILabel()
        label.text = "We climb, 위클"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor(named: "MainColor")
        
        return label
    }()
    
    private let kakaoLoginButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: "Kakao_Login_Button") {
            button.setBackgroundImage(buttonImage, for: .normal)
        } else {
            print("이미지 없는데?")
        }
        return button
    }()
    
    private let appleLoginButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: "Apple_Login_Button") {
            button.setBackgroundImage(buttonImage, for: .normal)
        } else {
            print("이미지 없는데?")
        }
        return button
    }()
    
    private let googleLoginButton = {
        let button = UIButton(type: .system)
        if let buttonImage = UIImage(named: "Google_Login_Button") {
            button.setBackgroundImage(buttonImage, for: .normal)
        } else {
            print("이미지 없는데?")
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
                //탭바로 넘어갈 때 네비게이션바 가리기
                self?.navigationController?.setNavigationBarHidden(true, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = .systemBackground
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
