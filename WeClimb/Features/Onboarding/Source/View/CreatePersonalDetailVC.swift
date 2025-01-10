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
        label.layer.cornerRadius = OnboardingConst.PersonalDetail.CornerRadius.pageControl
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
        stackView.spacing = OnboardingConst.PersonalDetail.Spacing.stackViewSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let armrichTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = OnboardingConst.PersonalDetail.Spacing.stackViewSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let heightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = OnboardingConst.PersonalDetail.Text.heightPlaceholder
        
        textField.borderStyle = .roundedRect
        textField.font = OnboardingConst.PersonalDetail.Font.placeholderFont
        textField.textColor = OnboardingConst.PersonalDetail.Color.textFieldLabelColor
        
        textField.backgroundColor = OnboardingConst.PersonalDetail.Color.backgroundColor
        textField.layer.cornerRadius = OnboardingConst.PersonalDetail.CornerRadius.textFieldCornerRadius
        textField.layer.borderWidth = OnboardingConst.PersonalDetail.Size.textFieldBorderWidth
        textField.layer.borderColor = OnboardingConst.PersonalDetail.Color.boarderGray.cgColor
        
        textField.attributedPlaceholder = NSAttributedString(
            string: OnboardingConst.PersonalDetail.Text.heightPlaceholder,
            attributes: [
                .foregroundColor: OnboardingConst.PersonalDetail.Color.placeholderTextFieldColor
            ]
        )
        return textField
    }()
    
    private let armrichTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = OnboardingConst.PersonalDetail.Text.armrichPlaceholder
        
        textField.borderStyle = .roundedRect
        textField.font = OnboardingConst.PersonalDetail.Font.placeholderFont
        textField.textColor = OnboardingConst.PersonalDetail.Color.textFieldLabelColor
        
        textField.backgroundColor = OnboardingConst.PersonalDetail.Color.backgroundColor
        textField.layer.cornerRadius = OnboardingConst.PersonalDetail.CornerRadius.textFieldCornerRadius
        textField.layer.borderWidth = OnboardingConst.PersonalDetail.Size.textFieldBorderWidth
        textField.layer.borderColor = OnboardingConst.PersonalDetail.Color.boarderGray.cgColor
        
        textField.attributedPlaceholder = NSAttributedString(
            string: OnboardingConst.PersonalDetail.Text.armrichPlaceholder,
            attributes: [
                .foregroundColor: OnboardingConst.PersonalDetail.Color.placeholderTextFieldColor
            ]
        )
        return textField
    }()
    
    private let confirmButton: WeClimbButton = {
        let button = WeClimbButton(style: .defaultRectangle)
        button.setTitle(OnboardingConst.PersonalDetail.Text.nextPage, for: .normal)
        button.backgroundColor = OnboardingConst.PersonalDetail.Color.confirmActivationColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = OnboardingConst.PersonalDetail.CornerRadius.confirmButton
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
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.height.width.equalTo(OnboardingConst.PersonalDetail.Size.pageControlSize)
        }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OnboardingConst.PersonalDetail.Spacing.logoTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.height.width.equalTo(OnboardingConst.PersonalDetail.Size.logoSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(OnboardingConst.PersonalDetail.Spacing.titleTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
        }
        
        heightTitleStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(OnboardingConst.PersonalDetail.Spacing.titleStackViewTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.heightTitleStackViewSize)
        }
        
        heightTitleLabel.snp.makeConstraints {
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.heightTitleLabelSize)
        }
        
        requiredLabel.snp.makeConstraints {
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.requiredLabelSize)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(heightTitleStackView.snp.bottom).offset(OnboardingConst.PersonalDetail.Spacing.textFieldTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.height.equalTo(OnboardingConst.PersonalDetail.Size.heightTextFieldHeight)
        }
        
        armrichTitleStackView.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom).offset(OnboardingConst.PersonalDetail.Spacing.titleTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.armrichTitleStackViewSize)
        }
        
        armrichTitleLabel.snp.makeConstraints {
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.armrichTitleLabelSize)
        }
        
        selectionLabel.snp.makeConstraints {
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.selectionLabelSize)
        }
        
        armrichTextField.snp.makeConstraints {
            $0.top.equalTo(armrichTitleStackView.snp.bottom).offset(OnboardingConst.PersonalDetail.Spacing.textFieldTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.height.equalTo(OnboardingConst.PersonalDetail.Size.armrichTextFieldHeight)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OnboardingConst.PersonalDetail.Spacing.confirmButtonBottomSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
        }
    }
}
