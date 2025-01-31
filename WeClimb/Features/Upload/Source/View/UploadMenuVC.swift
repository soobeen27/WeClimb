//
//  UploadMenuView.swift
//  WeClimb
//
//  Created by 강유정 on 1/24/25.
//
//

import UIKit

import SnapKit

class UploadMenuVC: UIViewController {
    var coordinator: UploadCoordinator?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 게시물인가요?"
        label.font = UIFont.customFont(style: .label1SemiBold)
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "게시물의 유형을 선택해주세요."
        label.font = UIFont.customFont(style: .body2Regular)
        label.textAlignment = .left
        label.textColor = .labelNeutral
        return label
    }()
    
    private let climbingButton: UIButton = {
        let button = UIButton()
        button.setTitle("완등", for: .normal)
        button.titleLabel?.font = UIFont.customFont(style: .label2Medium)
        button.setTitleColor(.labelNeutral, for: .normal)
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    var onClimbingButtonTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setButton()
        setLayout()
    }
    
    private func addTopBorderToButton(_ button: UIButton) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.lineSolidLight.cgColor
        borderLayer.frame = CGRect(x: -16, y: 0, width: 250, height: 1)
        
        button.layer.addSublayer(borderLayer)
    }
    
    private func setView() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 10
    }
    
    private func setButton() {
        climbingButton.addTarget(self, action: #selector(climbingButtonTapped), for: .touchUpInside)
        addTopBorderToButton(climbingButton)
    }
    
    private func setLayout() {
        [titleLabel, descriptionLabel, climbingButton]
            .forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(22)
        }
        
        climbingButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
    }
    
    @objc private func climbingButtonTapped() {
        onClimbingButtonTapped?()
    }
}
