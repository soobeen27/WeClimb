//
//  UserInformationVC.swift
//  WeClimb
//
//  Created by 머성이 on 9/5/24.
//

import UIKit

import SnapKit
import RxSwift

class CreateNickNameVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = CreateNickNameVM()
    private let profileImagePicker = ProfileImagePickerVC()
    private let createNickNameVM = CreateNickNameVM()
    
    var selectedImage: UIImage?
    
    private let logoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoText")?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.mainPurple
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 프로필로 참여할까요?"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "testStone") // 기본 프로필 이미지
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 55
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
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindViewModel()
        addProfileImageButtonTap()
        
        nicknameTextField.delegate = self
        registerForKeyboardNotifications()
    }
    
    // 키보드 알림 등록
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드 알림 해제
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 키보드가 나타났을 때
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height / 10// 뷰를 키보드 크기의 절반만큼 위로 이동
        }
    }
    
    // 키보드가 사라졌을 때
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0  // 뷰를 원래 위치로 복귀
        }
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        self.overrideUserInterfaceStyle = .light
        
        [
            logoView,
            titleLabel,
            profileImageView,
            addProfileImageButton,
            nicknameTextField,
            characterCountLabel,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        logoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(40)
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.width.height.equalTo(110)
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
    
    //MARK: - 탭 제스처를 추가하고, 이미지 피커 띄우기
    private func addProfileImageButtonTap() {
        let tapGesture = UITapGestureRecognizer()
        addProfileImageButton.isUserInteractionEnabled = true
        addProfileImageButton.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                // 현재 인스턴스 메서드에 넣어주기
                self.profileImagePicker.presentImagePicker(from: self)
            })
            .disposed(by: disposeBag)
        
        // 이미지 선택 후 ViewModel에 이미지 전달
        profileImagePicker.imageObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                
                if let selectedImage = image {
                    print("프로필 사진 선택됨")
                    self.selectedImage = selectedImage
                    self.profileImageView.image = selectedImage
                    
                    // 이미지를 로컬 URL로 변환
                    if let imageUrl = self.saveImageToLocal(selectedImage) {
                        print("이미지 변환 성공")
                        self.createNickNameVM.uploadProfileImage(imageUrl: imageUrl)
                    } else {
                        print("이미지 변환 실패")
                    }
                } else {
                    print("프로필 사진이 선택되지 않음")
                }
            })
            .disposed(by: disposeBag)
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
        
        // 닉네임 중복 여부 확인
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                // 키보드 숨기기
                self?.nicknameTextField.resignFirstResponder()
                self?.viewModel.checkNicknameDuplication()
            })
            .disposed(by: disposeBag)
        
        // 닉네임 중복 체크 결과에 따라 처리
        viewModel.isNicknameDuplicateCheck
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isDuplicate in
                guard let self = self else { return }
                
                if isDuplicate {
                    // 닉네임 중복일 경우 알림 표시
                    CommonManager.shared.showAlert(
                        from: self,
                        title: "중복된 닉네임",
                        message: "이미 사용중인 닉네임입니다. 다른 닉네임을 입력해주세요.",
                        includeCancel: false
                    )
                } else {
                    // 닉네임 중복이 아닐 경우 네비게이션 실행
                    guard let newName = try? self.viewModel.nicknameInput.value() else { return }
                    FirebaseManager.shared.updateAccount(with: newName, for: .userName, completion: {
                        let personalDetailVC = PersonalDetailsVC()
                        self.navigationController?.pushViewController(personalDetailVC, animated: true)
                    })
                }
            })
            .disposed(by: disposeBag)
        
        createNickNameVM.uploadResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let url):
                    print("Image uploaded successfully, URL: \(url)")
                case .failure(let error):
                    print("Failed to upload image: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    // UIImage를 로컬 URL로 변환하는 함수
    func saveImageToLocal(_ image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            print("이미지 데이터 변환 실패")
            return nil
        }
        
        // 고유한 파일 이름 생성 및 임시 디렉토리에 저장
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            print("이미지 변환 성공 URL: \(fileURL.absoluteString)")
            return fileURL
        } catch {
            print("이미지 저장 실패: \(error.localizedDescription)")
            return nil
        }
    }
}

extension CreateNickNameVC: UITextFieldDelegate {
    // UITextFieldDelegate 메서드: 텍스트 입력 시 글자 수를 제한하는 로직
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.contains(" ") {
            return false
        }
        // 현재 텍스트 필드에 있는 텍스트와 새로 입력된 문자열을 합쳐서 미리 계산
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 글자 수가 12자 이하면 true, 초과하면 false로 입력을 막음
        return newText.count <= 12
    }
}
