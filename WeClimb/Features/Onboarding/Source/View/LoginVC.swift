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
    private let viewModel: LoginVM
    private let disposeBag = DisposeBag()
    
    init(coordinator: LoginCoordinator? = nil, viewModel: LoginVM) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func loginBind() {
        let input = LoginVM.Input(
            loginType: Observable.merge(
                googleLoginButton.rx.tap.map { LoginType.google },
                kakaoLoginButton.rx.tap.map { LoginType.kakao },
                appleLoginButton.rx.tap.map { LoginType.apple }
            ),
            loginButtonTapped: Observable.merge(
                googleLoginButton.rx.tap.asObservable(),
                kakaoLoginButton.rx.tap.asObservable(),
                appleLoginButton.rx.tap.asObservable()
            )
        )
        let output = viewModel.transform(input: input)
        
        output.loginResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    //코디네이터 네비게이션
                    print(result)
                case .failure(let error):
                    //에러처리
                    print("에러")
                }
            })
            .disposed(by: disposeBag)
    }
}
