//
//  CreateNicknameVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit

class CreateNicknameVC: UIViewController {
    var coordinator: CreateNickNameCoordinator?
    
    private let logoImage: UIImageView = {
        var image = UIImageView()
        image.image = OnboardingConst.PrivacyPolicy.Image.weclimbLogo
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.CreateNickname.Text.titleLabel
        label.font = OnboardingConst.CreateNickname.Font.titleFont
        label.numberOfLines = OnboardingConst.CreateNickname.Text.titleNumberofLine
        label.textColor = OnboardingConst.CreateNickname.Color.titleTextColor
        return label
    }()
    
    private let pageController: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.CreateNickname.Text.pageControl
        label.textColor = OnboardingConst.CreateNickname.Color.pageControlTextColor
        label.font = OnboardingConst.CreateNickname.Font.valueFont
        label.layer.cornerRadius = 16
        label.contentMode = .center
        return label
    }()
    
    private let nickNameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.CreateNickname.Text.nickNameTitle
        label.textColor = OnboardingConst.CreateNickname.Color.titleTextColor
        label.font = OnboardingConst.CreateNickname.Font.nickNameTitle
        return label
    }()
    
    private let nickNameSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.CreateNickname.Text.nickNameSub
        label.textColor = OnboardingConst.CreateNickname.Color.subtitleTextColor
        label.font = OnboardingConst.CreateNickname.Font.valueFont
        return label
    }()
    
    private let nickNameTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 3
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = OnboardingConst.CreateNickname.Text.nicknamePlaceholder
        
        textField.borderStyle = .roundedRect
        textField.font = OnboardingConst.CreateNickname.Font.placeholderFont
        textField.textColor = OnboardingConst.CreateNickname.Color.nickNameLabelColor
        
        textField.backgroundColor = OnboardingConst.CreateNickname.Color.backgroundColor
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = OnboardingConst.CreateNickname.Color.boarderGray.cgColor
        
        textField.attributedPlaceholder = NSAttributedString(
            string: OnboardingConst.CreateNickname.Text.nicknamePlaceholder,
            attributes: [
                .foregroundColor: OnboardingConst.CreateNickname.Color.nickNameFieldColor
            ]
        )
        return textField
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.CreateNickname.Text.charCountLabel
        label.font = OnboardingConst.CreateNickname.Font.valueFont
        label.textColor = OnboardingConst.CreateNickname.Color.subtitleTextColor
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(OnboardingConst.PrivacyPolicy.Text.nextPage, for: .normal)
        button.backgroundColor = UIColor.lightGray
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
            nickNameTitleLabel,
            nickNameSubTitleLabel,
        ].forEach { nickNameTitleStackView.addArrangedSubview($0) }
        
        [
            logoImage,
            titleLabel,
            pageController,
            nickNameTitleStackView,
            nickNameTextField,
            characterCountLabel,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        pageController.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(26)
            $0.width.equalTo(41)
        }
        
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
        
        nickNameTitleStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(62)
            $0.height.equalTo(21)
        }
        
        nickNameTitleLabel.snp.makeConstraints {
            $0.width.equalTo(37)
            $0.height.equalTo(21)
        }
        
        nickNameSubTitleLabel.snp.makeConstraints {
            $0.width.equalTo(21)
            $0.height.equalTo(16)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameTitleStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(46)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(30)
            $0.height.equalTo(16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
}
