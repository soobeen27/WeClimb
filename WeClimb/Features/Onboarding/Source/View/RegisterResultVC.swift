//
//  RegisterResultVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class RegisterResultVC: UIViewController {
    var coordinator: RegisterResultCoordinator?
    var disposeBag = DisposeBag()
    
    var onTabBarPage: (() -> Void)?
    
    private let logoImage: UIImageView = {
        var image = UIImageView()
        image.image = OnboardingConst.weclimbLogo
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.RegisterResult.Text.titleLabel
        label.font = OnboardingConst.RegisterResult.Font.titleFont
        label.numberOfLines = OnboardingConst.RegisterResult.Text.titleNumberofLine
        label.textColor = OnboardingConst.RegisterResult.Color.titleTextColor
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.RegisterResult.Text.GreetingComment
        label.textColor = OnboardingConst.RegisterResult.Color.greetingCommentColor
        label.font = OnboardingConst.RegisterResult.Font.valueFont
        return label
    }()
    
    private let confirmButton: WeClimbButton = {
        let button = WeClimbButton(style: .defaultRectangle)
        button.setTitle(OnboardingConst.RegisterResult.Text.confirmText, for: .normal)
        button.backgroundColor = OnboardingConst.RegisterResult.Color.confirmColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = OnboardingConst.RegisterResult.CornerRadius.confirmButton
        button.isEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        confirmButtonTapped()
    }
    
    private func setLayout() {
        view.backgroundColor = OnboardingConst.CreateNickname.Color.backgroundColor
        
        [
            logoImage,
            titleLabel,
            commentLabel,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OnboardingConst.RegisterResult.Spacing.logoTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.RegisterResult.Spacing.baseSpacing)
            $0.width.height.equalTo(OnboardingConst.RegisterResult.Size.logoSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(OnboardingConst.RegisterResult.Spacing.baseSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.RegisterResult.Spacing.baseSpacing)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.RegisterResult.Spacing.baseSpacing)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(OnboardingConst.RegisterResult.Spacing.commentTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.RegisterResult.Spacing.baseSpacing)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.RegisterResult.Spacing.baseSpacing)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OnboardingConst.RegisterResult.Spacing.confirmBottomSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.RegisterResult.Spacing.baseSpacing)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.RegisterResult.Spacing.baseSpacing)
        }
    }
    
    private func confirmButtonTapped() {
        confirmButton.rx.tap
            .bind { [weak self] in
                self?.onTabBarPage?()
            }
            .disposed(by: disposeBag)
    }
}
