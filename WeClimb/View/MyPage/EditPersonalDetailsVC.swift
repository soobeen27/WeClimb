//
//  EditPersonalDetailsVC.swift
//  WeClimb
//
//  Created by 김솔비 on 9/23/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class EditPersonalDetailsVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = PersonalDetailsVM()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "수정할 정보를 입력해 주세요"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let titleDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "회원님에게 더 좋은 클라이밍 정보를 전달해드릴게요!"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "키"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let heightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("cm", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.95)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let armReachLabel: UILabel = {
        let label = UILabel()
        label.text = "팔길이"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let armReachButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("cm", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.95)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = UIColor.mainPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        //        button.isEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupBindings()
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        
        [
            titleLabel,
            titleDetailLabel,
            heightLabel,
            heightButton,
            armReachLabel,
            armReachButton,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(62)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        titleDetailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(titleDetailLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
        
        heightButton.snp.makeConstraints {
            $0.centerY.equalTo(heightLabel)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(160)
            $0.height.equalTo(40)
        }
        
        armReachLabel.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
        
        armReachButton.snp.makeConstraints {
            $0.centerY.equalTo(armReachLabel)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(160)
            $0.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    private func setupBindings() {
        heightButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                let rangePickerVC = RangePickerVC()
                
                rangePickerVC.modalPresentationStyle = .pageSheet
                if let sheet = rangePickerVC.sheetPresentationController {
                    sheet.detents = [.custom { _ in
                        return 296
                    }]
                    sheet.preferredCornerRadius = 24
                }
                
                rangePickerVC.selectedRange
                    .subscribe(onNext: { [weak self] selectedRange in
                        self?.heightButton.setTitle("\(selectedRange) cm", for: .normal)
                        self?.viewModel.heightInput.accept(selectedRange)  // onNext 대신 accept 사용
                    })
                    .disposed(by: self.disposeBag)
                
                self.present(rangePickerVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        
        armReachButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let rangePickerVC = RangePickerVC()
                
                rangePickerVC.modalPresentationStyle = .pageSheet
                if let sheet = rangePickerVC.sheetPresentationController {
                    sheet.detents = [.custom { _ in
                        return 296
                    }]
                    sheet.preferredCornerRadius = 24
                }
                
                rangePickerVC.selectedRange
                    .subscribe(onNext: { [weak self] selectedRange in
                        self?.armReachButton.setTitle("\(selectedRange) cm", for: .normal)
                        self?.viewModel.armReachInput.accept(selectedRange)  // BehaviorRelay 값 업데이트
                    })
                    .disposed(by: self.disposeBag)
                
                self.present(rangePickerVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        // 버튼 항상 활성화
        //        Observable.merge(
        //            viewModel.heightInput.map { _ in true },
        //            viewModel.armReachInput.map { _ in true }
        //        )
        //        .bind(to: confirmButton.rx.isEnabled)
        //        .disposed(by: disposeBag)
        
        // heightInput과 armReachInput 결합
        Observable.combineLatest(viewModel.heightInput, viewModel.armReachInput)
            .subscribe(onNext: { [weak self] newHeight, newArmReach in
                guard let self = self else { return }
                
                self.confirmButton.rx.tap
                    .subscribe(onNext: {
                        print("ConfirmButton tapped _ height: \(newHeight) armReach: \(newArmReach)")
                        FirebaseManager.shared.updateAccount(with: newHeight, for: .height) {
                            FirebaseManager.shared.updateAccount(with: newArmReach, for: .armReach, completion: {
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "정보 수정이 완료 되었습니다", message: nil, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                                        self.navigationController?.popViewController(animated: true)
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            })
                        }
                    })
                    .disposed(by: self.disposeBag) // 내부 subscribe의 구독 해제
            })
            .disposed(by: disposeBag) // 외부 Observable의 구독 해제
        
        //        // 버튼 탭 이벤트와 입력 조합을 결합해서 탭할 때마다 최신 입력 값을 사용
        //        Observable.combineLatest(viewModel.heightInput, viewModel.armReachInput)
        //            .subscribe(onNext: { [weak self] newHeight, newArmReach in
        //                guard let self = self else { return }
        //
        //                // 네비게이션
        //                self.confirmButton.rx.tap
        //                    .subscribe(onNext: {
        //                        print("Confirmbutton tapped")
        //                        FirebaseManager.shared.updateAccount(with: newHeight, for: .height) {
        //                            FirebaseManager.shared.updateAccount(with: newArmReach, for: .armReach, completion: {
        //                                DispatchQueue.main.async {
        //                                    let alert = UIAlertController(title: "정보 수정이 완료되었습니다", message: nil, preferredStyle: .alert)
        //                                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
        //                                        self.navigationController?.popViewController(animated: true)
        //                                    }))
        //                                    self.present(alert, animated: true, completion: nil)
        //                                }
        //                            })
        //                        }
        //                    })
        //                    .disposed(by: self.disposeBag)
        //            })
        //            .disposed(by: disposeBag)
    }
}

