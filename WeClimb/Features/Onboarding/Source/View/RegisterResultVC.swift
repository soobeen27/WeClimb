//
//  RegisterResultVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit

class RegisterResultVC: UIViewController {
    var coordinator: RegisterResultCoordinator?
    
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
        label.textColor = OnboardingConst.RegisterResult.Color.GreetingCommentColor
        label.font = OnboardingConst.RegisterResult.Font.valueFont
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작", for: .normal)
        button.backgroundColor = UIColor.purple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
}
