//
//  PrivacyPolicyVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit

class PrivacyPolicyVC: UIViewController {
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: PrivacyPolicy.logoImage)
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = PrivacyPolicy.titleLabel
        // 폰트 바꿔야함
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textColor = UIColor.black
        return label
    }()
    
    private let pageController: UILabel = {
        let label = UILabel()
        label.text = PrivacyPolicy.pageControll
        label.textColor = UIColor.black
        // 폰트 바꿔야함
        label.font = UIFont.systemFont(ofSize: 12)
        label.layer.backgroundColor = UIColor.customlightGray.cgColor
        label.layer.cornerRadius = 8
        return label
    }()
    
    private let allAgreeCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: PrivacyPolicy.clickCheckBox), for: .selected)
        button.setImage(UIImage(named: PrivacyPolicy.clearCheckBox), for: .normal)
        button.setTitle(PrivacyPolicy.isAllAgree, for: .normal)
        button.contentHorizontalAlignment = .left
        // 폰트 바꿔야함
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let isAppTermsAgreedCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: PrivacyPolicy.clickCheckBox), for: .selected)
        button.setImage(UIImage(named: PrivacyPolicy.clearCheckBox), for: .normal)
        button.setTitle(PrivacyPolicy.isAppTermsAgreed, for: .normal)
        button.contentHorizontalAlignment = .left
        //폰트 바꿔야함
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.titleLabel?.numberOfLines = 2
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }()
    
    private let isPrivacyTermsAgreedCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: PrivacyPolicy.clickCheckBox), for: .selected)
        button.setImage(UIImage(named: PrivacyPolicy.clearCheckBox), for: .normal)
        button.setTitle(PrivacyPolicy.isPrivacyTermsAgreed, for: .normal)
        button.contentHorizontalAlignment = .left
        //폰트 바꿔야함
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    private let isSnsConsentGivenCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: PrivacyPolicy.clickCheckBox), for: .selected)
        button.setImage(UIImage(named: PrivacyPolicy.clearCheckBox), for: .normal)
        button.setTitle(PrivacyPolicy.isSNSConsenctGivenCheck, for: .normal)
        button.contentHorizontalAlignment = .left
        //폰트 바꿔야함
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    private let checkBoxStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.backgroundColor = UIColor.customlightGray
        return stackView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(PrivacyPolicy.nextPage, for: .normal)
        button.backgroundColor = UIColor.customlightGray
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
        
        let text = PrivacyPolicy.termsText
        let attributedString = NSMutableAttributedString(string: text)
        
        let termsRange = (text as NSString).range(of: PrivacyPolicy.termsRange)
        let privacyPolicyRange = (text as NSString).range(of: PrivacyPolicy.privacyPolicyRange)
        
        attributedString.addAttribute(.link, value: PrivacyPolicy.termslink, range: termsRange)
        attributedString.addAttribute(.link, value: PrivacyPolicy.privacyPolicylink, range: privacyPolicyRange)
        
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
            checkBoxStackView,
            confirmButton,
            termsTextView,
        ].forEach { view.addSubview($0) }
        
        [
            isAppTermsAgreedCheckBox,
            isPrivacyTermsAgreedCheckBox,
            isSnsConsentGivenCheckBox,
        ].forEach { checkBoxStackView.addArrangedSubview($0) }
        
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
        
        checkBoxStackView.snp.makeConstraints {
            $0.top.equalTo(allAgreeCheckBox.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(127)
            $0.width.equalTo(343)
        }
        
        isAppTermsAgreedCheckBox.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.width.equalTo(311)
        }
        
        isPrivacyTermsAgreedCheckBox.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.width.equalTo(311)
        }
        
        isSnsConsentGivenCheckBox.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.width.equalTo(311)
        }
        
        termsTextView.snp.makeConstraints {
            $0.top.equalTo(checkBoxStackView.snp.bottom).offset(16)
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
