//
//  SignUpVC.swift
//  WeClimb
//
//  Created by 머성이 on 9/4/24.
//

import UIKit

import SnapKit
import RxSwift

class PrivacyPolicyVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: PrivacyPolicyVMType
    
    init(viewModel: PrivacyPolicyVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setLayout()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoText")?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.mainPurple
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스 이용에 동의해\n주세요!"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textColor = UIColor.black
        return label
    }()
    
    private let allAgreeCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setTitle(" 약관 모두 동의", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        return button
    }()
    
    private let isAppTermsAgreedCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setTitle(" (필수) WeClimb 이용약관", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    private let isPrivacyTermsAgreedCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setTitle(" (필수) WeClimb 개인정보 수집 및 이용에 대한 동의", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    private let isSnsConsentGivenCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setTitle(" (선택) SNS 광고성 정보 수신동의", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("동의", for: .normal)
        button.backgroundColor = .lightGray
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
        textView.dataDetectorTypes = [.link] // 링크 감지
        
        // 링크 텍스트 설정
        let text = "이용약관  및  개인정보 처리방침"
        let attributedString = NSMutableAttributedString(string: text)
        
        // 링크 범위 설정
        let termsRange = (text as NSString).range(of: "이용약관")
        let andRange = (text as NSString).range(of: "및")
        let privacyPolicyRange = (text as NSString).range(of: "개인정보 처리방침")
        
        attributedString.addAttribute(.link, value: "https://www.notion.so/iosclimber/104292bf48c947b2b3b7a8cacdf1d130", range: termsRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray, range: andRange)
        attributedString.addAttribute(.link, value: "https://www.notion.so/iosclimber/146cdb8937944e18a0e055c892c52928", range: privacyPolicyRange)
        
        textView.attributedText = attributedString
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                                       NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        
        textView.textAlignment = .right
        
        return textView
    }()
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        termsTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        
        [
            logoImage,
            titleLabel,
            allAgreeCheckBox,
            isAppTermsAgreedCheckBox,
            isPrivacyTermsAgreedCheckBox,
            isSnsConsentGivenCheckBox,
            termsTextView,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        allAgreeCheckBox.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        isAppTermsAgreedCheckBox.snp.makeConstraints {
            $0.top.equalTo(allAgreeCheckBox.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        isPrivacyTermsAgreedCheckBox.snp.makeConstraints {
            $0.top.equalTo(isAppTermsAgreedCheckBox.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        isSnsConsentGivenCheckBox.snp.makeConstraints {
            $0.top.equalTo(isPrivacyTermsAgreedCheckBox.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        termsTextView.snp.makeConstraints {
            $0.top.equalTo(isSnsConsentGivenCheckBox.snp.bottom).offset(35)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    private func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        let input = PrivacyPolicyVM.Input(
            allTermsToggled: allAgreeCheckBox.rx.tap.asObservable(),
            appTermsToggled: isAppTermsAgreedCheckBox.rx.tap.asObservable(),
            privacyTermsToggled: isPrivacyTermsAgreedCheckBox.rx.tap.asObservable(),
            snsConsentToggled: isSnsConsentGivenCheckBox.rx.tap.asObservable()
        )
        
        _ = viewModel.transform(input: input)
    }
    
    private func bindOutputs() {
        let output = viewModel.transform(input: PrivacyPolicyVM.Input(
            allTermsToggled: allAgreeCheckBox.rx.tap.asObservable(),
            appTermsToggled: isAppTermsAgreedCheckBox.rx.tap.asObservable(),
            privacyTermsToggled: isPrivacyTermsAgreedCheckBox.rx.tap.asObservable(),
            snsConsentToggled: isSnsConsentGivenCheckBox.rx.tap.asObservable()
        ))
        
        output.isAllAgreed
            .bind(to: allAgreeCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isAppTermsAgreed
            .bind(to: isAppTermsAgreedCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isPrivacyTermsAgreed
            .bind(to: isPrivacyTermsAgreedCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isSnsConsentGiven
            .bind(to: isSnsConsentGivenCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isConfirmEnabled
            .map { $0 ? UIColor.systemBlue : UIColor.lightGray }
            .bind(to: confirmButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.isConfirmEnabled
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

extension PrivacyPolicyVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
