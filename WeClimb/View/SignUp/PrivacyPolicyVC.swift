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
    private let viewModel = PrivacyPolicyVM()
    
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
    
    private let termsCheckBox1: UIButton = {
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
    
    private let termsCheckBox2: UIButton = {
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
    
    private let termsCheckBox3: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setTitle(" (필수) WeClimb 위치정보 이용동의 및 위치기반서비스 이용약관", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    private let termsCheckBox4: UIButton = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindViewModel()
        
        termsTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        self.title = "WeClimb"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 투명도 없는 배경 설정
        appearance.backgroundColor = .white // 원하는 배경 색상 설정
        appearance.shadowColor = nil
        
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32),
            NSAttributedString.Key.foregroundColor: UIColor.mainPurple
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        
        [
            titleLabel,
            allAgreeCheckBox,
            termsCheckBox1,
            termsCheckBox2,
            termsCheckBox3,
            termsCheckBox4,
            termsTextView,
            confirmButton
        ].forEach { view.addSubview($0) }
    
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        allAgreeCheckBox.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        termsCheckBox1.snp.makeConstraints {
            $0.top.equalTo(allAgreeCheckBox.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        termsCheckBox2.snp.makeConstraints {
            $0.top.equalTo(termsCheckBox1.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        termsCheckBox3.snp.makeConstraints {
            $0.top.equalTo(termsCheckBox2.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        termsCheckBox4.snp.makeConstraints {
            $0.top.equalTo(termsCheckBox3.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        termsTextView.snp.makeConstraints {
            $0.top.equalTo(termsCheckBox4.snp.bottom).offset(35)
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
        // ViewModel과 View를 바인딩
        viewModel.isAllAgreed
            .bind(to: allAgreeCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.isTerms1Agreed
            .bind(to: termsCheckBox1.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.isTerms2Agreed
            .bind(to: termsCheckBox2.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.isTerms3Agreed
            .bind(to: termsCheckBox3.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.isTerms4Agreed
            .bind(to: termsCheckBox4.rx.isSelected) // 선택 항목 처리
            .disposed(by: disposeBag)
        
        // 필수 약관 모두 동의 색상과 테두리 업데이트
        viewModel.isAllAgreed
            .map { $0 ? UIColor.mainPurple : .systemGray3 }
            .subscribe(onNext: { [weak self] color in
                self?.allAgreeCheckBox.setTitleColor(color, for: .normal)
                self?.allAgreeCheckBox.layer.borderColor = color.cgColor
            })
            .disposed(by: disposeBag)
        
        // 필수 항목 체크박스 색상 업데이트
        viewModel.isTerms1Agreed
            .map { $0 ? UIColor.systemBlue : .systemGray3 }
            .subscribe(onNext: { [weak self] color in
                self?.termsCheckBox1.setTitleColor(color, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.isTerms2Agreed
            .map { $0 ? UIColor.systemBlue : .systemGray3 }
            .subscribe(onNext: { [weak self] color in
                self?.termsCheckBox2.setTitleColor(color, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.isTerms3Agreed
            .map { $0 ? UIColor.systemBlue : .systemGray3 }
            .subscribe(onNext: { [weak self] color in
                self?.termsCheckBox3.setTitleColor(color, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.isTerms4Agreed
            .map { $0 ? UIColor.systemBlue : .systemGray3 } // 선택 항목 처리
            .subscribe(onNext: { [weak self] color in
                self?.termsCheckBox4.setTitleColor(color, for: .normal)
            })
            .disposed(by: disposeBag)
        
        // 전부 동의되었을 때 버튼 색상
        viewModel.isAllAgreed
            .map { $0 ? UIColor.mainPurple : .lightGray }
            .bind(to: confirmButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.isAllAgreed
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 버튼 액션 처리
        allAgreeCheckBox.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.toggleAllTerms()
            })
            .disposed(by: disposeBag)
        
        termsCheckBox1.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.toggleTerms1()
            })
            .disposed(by: disposeBag)
        
        termsCheckBox2.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.toggleTerms2()
            })
            .disposed(by: disposeBag)
        
        termsCheckBox3.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.toggleTerms3()
            })
            .disposed(by: disposeBag)
        
        termsCheckBox4.rx.tap // 선택 항목에 대한 액션 처리
            .subscribe(onNext: { [weak self] in
                self?.viewModel.toggleTerms4()
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let personalDetailsVC = CreateNickNameVC()
                self?.navigationController?.pushViewController(personalDetailsVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension PrivacyPolicyVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
