//
//  PersonalDetailsVC.swift
//  WeClimb
//
//  Created by 머성이 on 9/5/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class PersonalDetailsVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = PersonalDetailsVM()
    
    private let logoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoText")?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.mainPurple
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "정보를 더 알려주세요!"
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
    
    private let heightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "키를 입력하세요"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let armReachLabel: UILabel = {
        let label = UILabel()
        label.text = "팔길이"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let armReachTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "팔 길이를 입력하세요"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = UIColor.mainPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = true
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
            logoView,
            titleLabel,
            titleDetailLabel,
            heightLabel,
            heightTextField,
            armReachLabel,
            armReachTextField,
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
            $0.height.equalTo(40)
        }
        
        titleDetailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(titleDetailLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
        
        heightTextField.snp.makeConstraints {
            $0.centerY.equalTo(heightLabel)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(160)
            $0.height.equalTo(40)
        }
        
        armReachLabel.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
        
        armReachTextField.snp.makeConstraints {
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
        let heightObservable = heightTextField.rx.text.orEmpty
            .map { Int($0) }
        
        let armReachObservable = armReachTextField.rx.text.orEmpty
            .map { Int($0) }
        
        // 확인 버튼 눌렀을 때 Firebase 업데이트 요청
        confirmButton.rx.tap
            .withLatestFrom(Observable.combineLatest(heightObservable, armReachObservable))
            .subscribe(onNext: { [weak self] height, armReach in
                guard let self = self else { return }
                
                var data: [String: Any] = [:]
                if let height = height { data["height"] = height }
                if let armReach = armReach { data["armReach"] = armReach }
                
                self.viewModel.updateUserDetails(data: data)
            })
            .disposed(by: disposeBag)
        
        // Firebase 업데이트 성공 여부 구독
        viewModel.updateSuccess
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] success in
                guard let self = self else { return }
                
                if success {
                    print("사용자 정보 업데이트 성공!")
                    
                    let tabBarController = TabBarController()
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                } else {
                    print("사용자 정보 업데이트 실패.")
                }
            })
            .disposed(by: disposeBag)
    }
}
