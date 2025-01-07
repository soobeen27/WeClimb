//
//  CreatePersonalDetailVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit

class CreatePersonalDetailVC: UIViewController {
    var coordinator: CreatePersonalDetailCoordinator?
    
    private let logoImage: UIImageView = {
        var image = UIImageView()
        image.image = OnboardingConst.weclimbLogo
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PersonalDetail.Text.titleLabel
        label.font = OnboardingConst.PersonalDetail.Font.titleFont
        label.numberOfLines = OnboardingConst.PersonalDetail.Text.titleNumberofLine
        label.textColor = OnboardingConst.PersonalDetail.Color.titleTextColor
        return label
    }()
    
    private let pageController: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PersonalDetail.Text.pageControl
        label.textColor = OnboardingConst.PersonalDetail.Color.pageControlTextColor
        label.font = OnboardingConst.PersonalDetail.Font.valueFont
        label.layer.cornerRadius = 16
        label.contentMode = .center
        return label
    }()
    
    private let heightTitleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PersonalDetail.Text.heightTitleText
        label.textColor = OnboardingConst.PersonalDetail.Color.titleTextColor
        label.font = OnboardingConst.PersonalDetail.Font.textFiledTitleLabelFont
        return label
    }()
    
    private let armrichTitleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PersonalDetail.Text.armrichTitleText
        label.textColor = OnboardingConst.PersonalDetail.Color.titleTextColor
        label.font = OnboardingConst.PersonalDetail.Font.textFiledTitleLabelFont
        return label
    }()
    
    private let selectionLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PersonalDetail.Text.selectionLabel
        label.textColor = OnboardingConst.PersonalDetail.Color.subtitleTextColor
        label.font = OnboardingConst.PersonalDetail.Font.valueFont
        return label
    }()
    
    private let requiredLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PersonalDetail.Text.requiredText
        label.textColor = OnboardingConst.PersonalDetail.Color.subtitleTextColor
        label.font = OnboardingConst.PersonalDetail.Font.valueFont
        return label
    }()
    
    private let heightTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 3
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let armrichTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 3
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let heightTextField: UITextField = {
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
    
    private let armrichTextField: UITextField = {
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
            heightTitleLabel,
            requiredLabel,
        ].forEach { heightTitleStackView.addArrangedSubview($0) }
        
        [
            armrichTitleLabel,
            selectionLabel,
        ].forEach { armrichTitleStackView.addArrangedSubview($0) }
        
        [
            logoImage,
            titleLabel,
            pageController,
            heightTitleStackView,
            armrichTitleStackView,
            heightTextField,
            armrichTextField,
            confirmButton,
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
        
        heightTitleStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(50)
            $0.height.equalTo(21)
        }
        
        heightTitleLabel.snp.makeConstraints {
            $0.width.equalTo(25)
            $0.height.equalTo(21)
        }
        
        requiredLabel.snp.makeConstraints {
            $0.width.equalTo(21)
            $0.height.equalTo(16)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(heightTitleStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(46)
        }
        
        armrichTitleStackView.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(62)
            $0.height.equalTo(21)
        }
        
        armrichTitleLabel.snp.makeConstraints {
            $0.width.equalTo(37)
            $0.height.equalTo(21)
        }
        
        selectionLabel.snp.makeConstraints {
            $0.width.equalTo(21)
            $0.height.equalTo(16)
        }
        
        armrichTextField.snp.makeConstraints {
            $0.top.equalTo(armrichTitleStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(46)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
}
