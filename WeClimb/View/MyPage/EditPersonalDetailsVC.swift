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
    
    private let armLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "팔길이"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let armLengthButton: UIButton = {
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
//        button.isEnabled = false
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
            armLengthLabel,
            armLengthButton,
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
        
        armLengthLabel.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
        
        armLengthButton.snp.makeConstraints {
            $0.centerY.equalTo(armLengthLabel)
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
                    })
                    .disposed(by: self.disposeBag)
                
                self.present(rangePickerVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        armLengthButton.rx.tap
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
                        self?.armLengthButton.setTitle("\(selectedRange) cm", for: .normal)
                    })
                    .disposed(by: self.disposeBag)
                
                self.present(rangePickerVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        // 네비게이션
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let tabBarController = TabBarController()
                self?.navigationController?.pushViewController(tabBarController, animated: true)
                //탭바로 넘어갈 때 네비게이션바 가리기
                self?.navigationController?.setNavigationBarHidden(true, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

