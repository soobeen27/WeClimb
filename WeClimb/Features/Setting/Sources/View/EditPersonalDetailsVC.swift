////
////  EditPersonalDetailsVC.swift
////  WeClimb
////
////  Created by 김솔비 on 9/23/24.
////
//
import UIKit

import SnapKit
import RxCocoa
import RxSwift

class EditPersonalDetailsVC: UIViewController {
    var coordinator: EditPageCoordinator?
}
//
//    private let disposeBag = DisposeBag()
//    private let viewModel = PersonalDetailsVM()
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "수정할 정보를 입력해 주세요"
//        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        label.textColor = .black
//        return label
//    }()
//    
//    private let titleDetailLabel: UILabel = {
//        let label = UILabel()
//        label.text = "회원님에게 더 좋은 클라이밍 정보를 전달해드릴게요!"
//        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
//        label.textColor = .lightGray
//        return label
//    }()
//    
//    private let heightLabel: UILabel = {
//        let label = UILabel()
//        label.text = "키"
//        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        label.textColor = .black
//        return label
//    }()
//    
//    private let heightTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "키를 입력하세요"
//        textField.font = UIFont.systemFont(ofSize: 18)
//        textField.textColor = .black
//        textField.borderStyle = .roundedRect
//        textField.keyboardType = .numberPad
//        return textField
//    }()
//    
//    //    private let heightButton: UIButton = {
//    //        let button = UIButton(type: .system)
//    //        button.setTitle("cm", for: .normal)
//    //        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//    //        button.setTitleColor(.white, for: .normal)
//    //        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.95)
//    //        button.layer.cornerRadius = 10
//    //        return button
//    //    }()
//    
//    private let armReachLabel: UILabel = {
//        let label = UILabel()
//        label.text = "팔길이"
//        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        label.textColor = .black
//        return label
//    }()
//    
//    private let armReachTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "팔길이를 입력하세요"
//        textField.font = UIFont.systemFont(ofSize: 18)
//        textField.textColor = .black
//        textField.borderStyle = .roundedRect
//        textField.keyboardType = .numberPad
//        return textField
//    }()
//    
//    //    private let armReachButton: UIButton = {
//    //        let button = UIButton(type: .system)
//    //        button.setTitle("cm", for: .normal)
//    //        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//    //        button.setTitleColor(.white, for: .normal)
//    //        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.95)
//    //        button.layer.cornerRadius = 10
//    //        return button
//    //    }()
//    
//    private let confirmButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("확인", for: .normal)
//        button.backgroundColor = UIColor.mainPurple
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 8
//        button.isEnabled = true
//        return button
//    }()
//    
//    func cmLabel() -> UILabel {
//        let label = UILabel()
//        label.text = "cm"
//        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        label.textColor = .black
//        return label
//    }
//    
//    lazy var cmLabel1 = cmLabel()
//    lazy var cmLabel2 = cmLabel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        updateUserInfo()
//        setLayout()
//        setupBindings()
//        addKeyboardObservers()
//    }
//    
//    // MARK: - 파이어베이스에 저장된 유저 정보 업데이트
//    func updateUserInfo() {
//        FirebaseManager.shared.currentUserInfo { [weak self] (result: Result<User, Error>) in
//            guard let self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let user):
//                    self.heightTextField.placeholder = "\(user.height ?? 0)"
//                    self.armReachTextField.placeholder = "\(user.armReach ?? 0)"
//                case .failure(let error):
//                    print("현재 유저 정보 가져오기 실패: \(error)")
//                }
//            }
//        }
//    }
//    
//    //    private func updateUserInfo() {
//    //        FirebaseManager.shared.currentUserInfo { [weak self] (result: Result<User, Error>) in
//    //            guard let self else { return }
//    //            DispatchQueue.main.async {
//    //                switch result {
//    //                case .success(let user):
//    //                    if let userHeight = user.height {  // user.height 값이 존재하면
//    //                        self.viewModel.heightInput.accept(userHeight)  // input에 저장
//    //                        self.heightButton.setTitle("\(String(describing: self.viewModel.heightInput.value)) cm", for: .normal)
//    //                    } else {
//    //                        self.viewModel.heightInput.accept(0)
//    //                    }
//    //                    if let userArmReach = user.armReach {
//    //                        self.viewModel.armReachInput.accept(userArmReach)
//    //                        self.armReachButton.setTitle("\(String(describing: self.viewModel.armReachInput.value)) cm", for: .normal)
//    //                    } else {
//    //                        self.viewModel.armReachInput.accept(0)
//    //                    }
//    //
//    //                case .failure(let error):
//    //                    print("현재 유저 정보 가져오기 실패: \(error)")
//    //                    self.heightButton.setTitle("cm", for: .normal)
//    //                    self.armReachButton.setTitle("cm", for: .normal)
//    //                }
//    //            }
//    //        }
//    //    }
//    
//    
//    //    // MARK: - 레이아웃
//    private func setLayout() {
//        view.backgroundColor = .white
//        self.overrideUserInterfaceStyle = .light
//        navigationController?.navigationBar.tintColor = UIColor.black
//        
//        [
//            titleLabel,
//            titleDetailLabel,
//            heightLabel,
//            heightTextField,
//            cmLabel1,
//            armReachLabel,
//            armReachTextField,
//            cmLabel2,
//            confirmButton
//        ].forEach { view.addSubview($0) }
//        
//        titleLabel.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(62)
//            $0.centerX.equalToSuperview()
//            $0.leading.equalToSuperview().offset(16)
//        }
//        
//        titleDetailLabel.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
//            $0.leading.equalToSuperview().offset(16)
//        }
//        
//        heightLabel.snp.makeConstraints {
//            $0.top.equalTo(titleDetailLabel.snp.bottom).offset(40)
//            $0.leading.equalToSuperview().offset(16)
//        }
//        
//        heightTextField.snp.makeConstraints {
//            $0.centerY.equalTo(heightLabel)
//            $0.trailing.equalToSuperview().offset(-50)
//            $0.width.equalTo(160)
//            $0.height.equalTo(40)
//        }
//        
//        //        heightButton.snp.makeConstraints {
//        //            $0.centerY.equalTo(heightLabel)
//        //            $0.trailing.equalToSuperview().offset(-16)
//        //            $0.width.equalTo(160)
//        //            $0.height.equalTo(40)
//        //        }
//        
//        armReachLabel.snp.makeConstraints {
//            $0.top.equalTo(heightLabel.snp.bottom).offset(40)
//            $0.leading.equalToSuperview().offset(16)
//        }
//        
//        armReachTextField.snp.makeConstraints {
//            $0.centerY.equalTo(armReachLabel)
//            $0.trailing.equalToSuperview().offset(-50)
//            $0.width.equalTo(160)
//            $0.height.equalTo(40)
//        }
//        
//        cmLabel1.snp.makeConstraints {
//            $0.centerY.equalTo(heightTextField.snp.centerY)
//            $0.trailing.equalToSuperview().inset(16)
//            $0.width.equalTo(30)
//            $0.height.equalTo(40)
//        }
//        
//        cmLabel2.snp.makeConstraints {
//            $0.centerY.equalTo(armReachTextField.snp.centerY)
//            $0.trailing.equalToSuperview().inset(16)
//            $0.width.equalTo(30)
//            $0.height.equalTo(40)
//        }
//        
//        //        armReachButton.snp.makeConstraints {
//        //            $0.centerY.equalTo(armReachLabel)
//        //            $0.trailing.equalToSuperview().offset(-16)
//        //            $0.width.equalTo(160)
//        //            $0.height.equalTo(40)
//        //        }
//        
//        confirmButton.snp.makeConstraints {
//            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
//            $0.leading.equalToSuperview().offset(16)
//            $0.trailing.equalToSuperview().offset(-16)
//            $0.height.equalTo(50)
//        }
//    }
//    
//    //MARK: - bind
//    private func setupBindings() {
//        let heightObservable = heightTextField.rx.text.orEmpty
//            .map { Int($0) }
//        
//        let armReachObservable = armReachTextField.rx.text.orEmpty
//            .map { Int($0) }
//        
//        // 확인 버튼 눌렀을 때 Firebase 업데이트 요청
//        confirmButton.rx.tap
//            .withLatestFrom(Observable.combineLatest(heightObservable, armReachObservable))
//            .subscribe(onNext: { [weak self] height, armReach in
//                guard let self = self else { return }
//                
//                var data: [String: Any] = [:]
//                if let height = height { data["height"] = height }
//                if let armReach = armReach { data["armReach"] = armReach }
//                
//                self.viewModel.updateUserDetails(data: data)
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(title: "정보 수정이 완료되었습니다", message: nil, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
//                        self.navigationController?.popViewController(animated: true)
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    
//    //MARK: - 키보드 on&off에 따른 버튼 애니메이션
//    private func addKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    private func removeKeyboardObservers() {
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    @objc
//    private func keyboardWillShow(notification: NSNotification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            UIView.animate(withDuration: 0.3) {
//                self.confirmButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + self.view.safeAreaInsets.bottom)
//            }
//        }
//    }
//    
//    @objc
//    private func keyboardWillHide(notification: NSNotification) {
//        UIView.animate(withDuration: 0.3) {
//            self.confirmButton.transform = .identity
//        }
//    }
//    
//    deinit {
//        removeKeyboardObservers()
//    }
//    
//    
//    //MARK: - 빈공간 터치 시 키보드 내리기
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//        super.touchesBegan(touches, with: event)
//    }
//}
//
//    
//    //    // MARK: - bind
////    private func setupBindings() {
//        //        heightButton.rx.tap
//        //            .subscribe(onNext: { [weak self] in
//        //                guard let self else { return }
//        //                let rangePickerVC = RangePickerVC()
//        //
//        //                rangePickerVC.modalPresentationStyle = .pageSheet
//        //                if let sheet = rangePickerVC.sheetPresentationController {
//        //                    sheet.detents = [.custom { _ in
//        //                        return 296
//        //                    }]
//        //                    sheet.preferredCornerRadius = 24
//        //                }
//        //
//        //                rangePickerVC.selectedRange
//        //                    .subscribe(onNext: { [weak self] selectedRange in
//        //                        self?.heightButton.setTitle("\(selectedRange) cm", for: .normal)
//        //                        self?.viewModel.heightInput.accept(selectedRange)  // onNext 대신 accept 사용
//        //                    })
//        //                    .disposed(by: self.disposeBag)
//        //
//        //                self.present(rangePickerVC, animated: true, completion: nil)
//        //            })
//        //            .disposed(by: disposeBag)
//        //
//        //
//        //        armReachButton.rx.tap
//        //            .subscribe(onNext: { [weak self] in
//        //                guard let self = self else { return }
//        //                let rangePickerVC = RangePickerVC()
//        //
//        //                rangePickerVC.modalPresentationStyle = .pageSheet
//        //                if let sheet = rangePickerVC.sheetPresentationController {
//        //                    sheet.detents = [.custom { _ in
//        //                        return 296
//        //                    }]
//        //                    sheet.preferredCornerRadius = 24
//        //                }
//        //
//        //                rangePickerVC.selectedRange
//        //                    .subscribe(onNext: { [weak self] selectedRange in
//        //                        self?.armReachButton.setTitle("\(selectedRange) cm", for: .normal)
//        //                        self?.viewModel.armReachInput.accept(selectedRange)  // BehaviorRelay 값 업데이트
//        //                    })
//        //                    .disposed(by: self.disposeBag)
//        //
//        //                self.present(rangePickerVC, animated: true, completion: nil)
//        //            })
//        //            .disposed(by: disposeBag)
//        //
//        //        // heightInput과 armReachInput 결합
//        //        Observable.combineLatest(viewModel.heightInput, viewModel.armReachInput)
//        //            .subscribe(onNext: { [weak self] newHeight, newArmReach in
//        //                guard let self = self else { return }
//        //
//        //        self.confirmButton.rx.tap
//        //            .subscribe(onNext: {
//        ////                print("ConfirmButton tapped _ height: \(newHeight) armReach: \(newArmReach)")
//        //                FirebaseManager.shared.updateAccount(with: newHeight, for: .height) {
//        //                    FirebaseManager.shared.updateAccount(with: newArmReach, for: .armReach, completion: {
//        //                        DispatchQueue.main.async {
//        //                            let alert = UIAlertController(title: "정보 수정이 완료 되었습니다", message: nil, preferredStyle: .alert)
//        //                            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
//        //                                self.navigationController?.popViewController(animated: true)
//        //                            }))
//        //                            self.present(alert, animated: true, completion: nil)
//        //                        }
//        //                    })
//        //                }
//        //            })
//        //            .disposed(by: self.disposeBag) // 내부 subscribe의 구독 해제
//            })
////        //            .disposed(by: disposeBag) // 외부 Observable의 구독 해제
////    }
////}
