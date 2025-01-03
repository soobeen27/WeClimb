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
        label.font = OnboardingConst.PrivacyPolicy.Font.pageControlFont
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
    
    private let checkBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = OnboardingConst.PrivacyPolicy.Color.containerBoxColor
        view.layer.cornerRadius = OnboardingConst.PrivacyPolicy.Style.containerCornerRadius
        return view
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(PrivacyPolicyNS.nextPage, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    private let termsTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = [.link]
        
        let text = PrivacyPolicyNS.termsText
        let attributedString = NSMutableAttributedString(string: text)
        
        let termsRange = (text as NSString).range(of: PrivacyPolicyNS.termsRange)
        let privacyPolicyRange = (text as NSString).range(of: PrivacyPolicyNS.privacyPolicyRange)
        
        attributedString.addAttribute(.link, value: PrivacyPolicyNS.termslink, range: termsRange)
        attributedString.addAttribute(.link, value: PrivacyPolicyNS.privacyPolicylink, range: privacyPolicyRange)
        
        textView.attributedText = attributedString
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                                       NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        
        textView.textAlignment = .left
        
        return textView
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
            checkBoxView,
            confirmButton,
            termsTextView,
        ].forEach { view.addSubview($0) }
        
        [
            isAppTermsAgreedCheckBox,
            isPrivacyTermsAgreedCheckBox,
            isSnsConsentGivenCheckBox,
        ].forEach { checkBoxView.addSubview($0) }
        
        pageController.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
        
        checkBoxView.snp.makeConstraints {
            $0.top.equalTo(allAgreeCheckBox.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(127)
            $0.width.equalTo(343)
        }
        
        isAppTermsAgreedCheckBox.snp.makeConstraints {
            $0.top.equalTo(allAgreeCheckBox.snp.top).offset(16)
            $0.height.equalTo(21)
            $0.leading.equalToSuperview().offset(16)
        }
        
        isPrivacyTermsAgreedCheckBox.snp.makeConstraints {
            $0.top.equalTo(isAppTermsAgreedCheckBox.snp.top).offset(16)
            $0.height.equalTo(21)
            $0.leading.equalToSuperview().offset(16)
        }
        
        isSnsConsentGivenCheckBox.snp.makeConstraints {
            $0.top.equalTo(isPrivacyTermsAgreedCheckBox.snp.top).offset(16)
            $0.height.equalTo(21)
            $0.leading.equalToSuperview().offset(16)
        }
        
        termsTextView.snp.makeConstraints {
            $0.top.equalTo(allAgreeCheckBox.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
}
