//
//  PrivacyPolicyVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit

class PrivacyPolicyVC: UIViewController {
    var coordinator: PrivacyPolicyCoordinator?
    
    private let logoImage: UIImageView = {
        var image = UIImageView()
        image.image = OnboardingConst.PrivacyPolicy.Image.weclimbLogo
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PrivacyPolicy.Text.titleLabel
        label.font = OnboardingConst.PrivacyPolicy.Font.titleFont
        label.numberOfLines = OnboardingConst.PrivacyPolicy.Text.titleNumberofLine
        label.textColor = OnboardingConst.PrivacyPolicy.Color.titleTextColor
        return label
    }()
    
    private let pageController: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PrivacyPolicy.Text.pageControl
        label.textColor = OnboardingConst.PrivacyPolicy.Color.pageControlTextColor
        label.font = OnboardingConst.PrivacyPolicy.Font.valueFont
        label.layer.cornerRadius = 16
        label.contentMode = .center
        return label
    }()
    
    private let allAgreeCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clickCheckBox, for: .selected)
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clearCheckBox, for: .normal)
        button.setTitle(OnboardingConst.PrivacyPolicy.Text.isAllAgree, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.titleCheckBoxFont
        button.setTitleColor(OnboardingConst.PrivacyPolicy.Color.CheckBoxFontColor, for: .normal)
        return button
    }()
    
    private let isAppTermsAgreedCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clickCheckBox, for: .selected)
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clearCheckBox, for: .normal)
        button.setTitle(OnboardingConst.PrivacyPolicy.Text.isAppTermsAgreed, for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(OnboardingConst.PrivacyPolicy.Color.CheckBoxFontColor, for: .normal)
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.valueCheckBoxFont
        return button
    }()
    
    private let isPrivacyTermsAgreedCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clickCheckBox, for: .selected)
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clearCheckBox, for: .normal)
        button.setTitle(OnboardingConst.PrivacyPolicy.Text.isPrivacyTermsAgreed, for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(OnboardingConst.PrivacyPolicy.Color.CheckBoxFontColor, for: .normal)
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.valueCheckBoxFont
        return button
    }()
    
    private let isSnsConsentGivenCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clickCheckBox, for: .selected)
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clearCheckBox, for: .normal)
        button.setTitle(OnboardingConst.PrivacyPolicy.Text.isSNSConsenctGivenCheck, for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(OnboardingConst.PrivacyPolicy.Color.CheckBoxFontColor, for: .normal)
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.valueCheckBoxFont
        return button
    }()
    
    private let checkBoxBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = OnboardingConst.PrivacyPolicy.Color.containerBoxColor
        view.layer.cornerRadius = OnboardingConst.PrivacyPolicy.Style.containerCornerRadius
        return view
    }()
    
    private let AppTermsAgreedLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.valueFont
        
        let buttonTitle = OnboardingConst.PrivacyPolicy.Text.AppTermAgreedButtonText
        let attributedString = NSMutableAttributedString(string: buttonTitle)
        
        attributedString.addAttributes([
            .foregroundColor: UIColor.systemGray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ], range: NSRange(location: 0, length: buttonTitle.count))
        
        button.setAttributedTitle(attributedString, for: .normal)
//        button.addTarget(self, action: #selector(appTermsButtonTapped), for: .touchUpInside)
        
        return button
    }()

    private let PrivacyTermsAgreedLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.valueFont
        
        let buttonTitle = OnboardingConst.PrivacyPolicy.Text.PrivacyTermsAgreedLinkButton
        let attributedString = NSMutableAttributedString(string: buttonTitle)
        
        attributedString.addAttributes([
            .foregroundColor: UIColor.systemGray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ], range: NSRange(location: 0, length: buttonTitle.count))
        
        button.setAttributedTitle(attributedString, for: .normal)
//        button.addTarget(self, action: #selector(privacyPolicyButtonTapped), for: .touchUpInside)
        
        return button
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
        view.backgroundColor = UIColor.white
        
        [
            logoImage,
            titleLabel,
            pageController,
            allAgreeCheckBox,
            checkBoxBackGroundView,
            AppTermsAgreedLinkButton,
            PrivacyTermsAgreedLinkButton,
            confirmButton,
//            termsTextView,
        ].forEach { view.addSubview($0) }
        
        [
            isAppTermsAgreedCheckBox,
            isPrivacyTermsAgreedCheckBox,
            isSnsConsentGivenCheckBox,
        ].forEach { checkBoxBackGroundView.addSubview($0) }
        
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
        
        allAgreeCheckBox.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        checkBoxBackGroundView.snp.makeConstraints {
            $0.top.equalTo(allAgreeCheckBox.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(127)
            $0.width.equalTo(343)
        }
        
        isAppTermsAgreedCheckBox.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(21)
            $0.leading.equalToSuperview().offset(16)
        }
        
        isPrivacyTermsAgreedCheckBox.snp.makeConstraints {
            $0.top.equalTo(isAppTermsAgreedCheckBox.snp.bottom).offset(16)
            $0.height.equalTo(21)
            $0.leading.equalToSuperview().offset(32)
        }
        
        isSnsConsentGivenCheckBox.snp.makeConstraints {
            $0.top.equalTo(isPrivacyTermsAgreedCheckBox.snp.bottom).offset(16)
            $0.height.equalTo(21)
            $0.leading.equalToSuperview().offset(16)
        }
        
        AppTermsAgreedLinkButton.snp.makeConstraints {
            $0.top.equalTo(checkBoxBackGroundView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(16)
            $0.width.equalTo(42)
        }
        PrivacyTermsAgreedLinkButton.snp.makeConstraints {
            $0.top.equalTo(AppTermsAgreedLinkButton .snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(16)
            $0.width.equalTo(83)
        }
//        termsTextView.snp.makeConstraints {
//            $0.top.equalTo(checkBoxBackGroundView.snp.bottom).offset(16)
//            $0.leading.equalToSuperview().offset(16)
//            $0.height.equalTo(40)
//            $0.width.equalTo(100)
//        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
}
