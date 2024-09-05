//
//  UserInformationVC.swift
//  WeClimb
//
//  Created by 머성이 on 9/5/24.
//

import UIKit

import SnapKit
import RxSwift

class PersonalDetailsVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = PersonalDetailsVM()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 프로필로 참여할까요?"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "testStone") // 기본 프로필 이미지
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let addProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/12"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindViewModel()
        
        nicknameTextField.delegate = self
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        
        [
            titleLabel,
            profileImageView,
            addProfileImageButton,
            nicknameTextField,
            characterCountLabel,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(40)
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.width.height.equalTo(120)
        }
        
        addProfileImageButton.snp.makeConstraints {
            $0.centerX.equalTo(profileImageView.snp.centerX)
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.width.height.equalTo(24)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(addProfileImageButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(40)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            $0.leading.equalTo(nicknameTextField.snp.leading)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(characterCountLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    private func bindViewModel() {
        // TextField 입력을 ViewModel에 바인딩
        nicknameTextField.rx.text.orEmpty
            .bind(to: viewModel.nicknameInput)
            .disposed(by: disposeBag)
        
        // 닉네임이 유효한지에 따라 버튼 활성화 및 색상 변경
        viewModel.isNicknameValid
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (isValid: Bool) in
                self?.confirmButton.isEnabled = isValid
                self?.confirmButton.backgroundColor = isValid ? UIColor.mainPurple : .lightGray
            })
            .disposed(by: disposeBag)
        
        // 글자 수 표시 업데이트
        viewModel.nicknameCharacterCount
            .bind(to: characterCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension PersonalDetailsVC: UITextFieldDelegate {
    // UITextFieldDelegate 메서드: 텍스트 입력 시 글자 수를 제한하는 로직
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트 필드에 있는 텍스트와 새로 입력된 문자열을 합쳐서 미리 계산
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 글자 수가 12자 이하면 true, 초과하면 false로 입력을 막음
        return newText.count <= 12
    }

}
