//
//  EditNickNameVC.swift
//  WeClimb
//
//  Created by 김솔비 on 9/22/24.
//

import UIKit

import SnapKit
import RxSwift

class EditNickNameVC: UIViewController, UITextFieldDelegate {
    
    private let disposeBag = DisposeBag()
    private let viewModel = CreateNickNameVM()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "수정할 닉네임을 입력해주세요"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
//        textField.placeholder = "닉네임을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = .white
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
        button.setTitle("저장", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindViewModel()
        setNavigationBar()
        updateUserInfo()
        
        nicknameTextField.delegate = self
        addKeyboardObservers()
    }
    
    private func setNavigationBar() {
        self.title = ""
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 1),
            NSAttributedString.Key.foregroundColor: UIColor.mainPurple
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    
    // MARK: - 파이어베이스에 저장된 유저 닉네임 업데이트
    private func updateUserInfo() {
        FirebaseManager.shared.currentUserInfo { [weak self] (result: Result<User, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    if let userName = user.userName {
                        self?.nicknameTextField.placeholder = "\(userName)"
                    } else {
                        self?.nicknameTextField.placeholder = "닉네임을 입력하세요"
                    }
                case .failure(let error):
                    print("현재 유저 정보 가져오기 실패: \(error)")
                    self?.nicknameTextField.placeholder = "닉네임을 입력하세요"
                }
            }
        }
    }
    
    
    //MARK: - 키보드 on&off에 따른 버튼 애니메이션
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.3) {
                self.confirmButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + self.view.safeAreaInsets.bottom)
            }
        }
    }
    
    @objc 
    private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.confirmButton.transform = .identity
        }
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    
    //MARK: - 빈공간 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    //MARK: - 글자수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.contains(" ") {
            return false
        }
        guard let currentText = textField.text as NSString? else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)
        return newText.count <= 12
    }
    
    
    //MARK: - 레이아웃
    private func setLayout() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor.black
        self.overrideUserInterfaceStyle = .light
        
        [
            titleLabel,
            nicknameTextField,
            characterCountLabel,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(52)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(40)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(40)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            $0.leading.equalTo(nicknameTextField.snp.leading)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    
    //MARK: - bind
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
        
        confirmButton.rx.tap
            .withLatestFrom(viewModel.nicknameInput) // nicknameInput의 최신 값 가져오기
            .subscribe(onNext: { [weak self] newName in
                guard let self else { return }
                FirebaseManager.shared.updateAccount(with: newName, for: .userName) {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "닉네임 수정이 완료되었습니다", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
