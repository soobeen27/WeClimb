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
        if let buttonImage = UIImage(named: "Kakao") {
            button.setImage(buttonImage, for: .normal)
        }
//        button.setTitle("Kakao로 계속하기", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
//        button.backgroundColor = UIColor(hex: "#FFCD00")
//        button.layer.borderWidth = 1.0
//        button.layer.borderColor = UIColor.systemGray3.cgColor
        return button
    }()
    
    private let appleLoginButton = {
        let button = UIButton()
        button.setTitle("Apple로 계속하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = .black
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.systemGray3.cgColor
        return button
    }()
    
    private let googleLoginButton = {
        let button = UIButton()
        button.setTitle("Google로 계속하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = .systemGray4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.systemGray3.cgColor
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
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        setLayout()
        buttonTapped()
    }
    
    private func buttonTapped() {
        guestLoginButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.pushViewController(TabBarController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = .white
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
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
    }
}
