//
//  UploadMenuView.swift
//  WeClimb
//
//  Created by 강유정 on 1/24/25.
//

import UIKit

import SnapKit

class UploadMenuView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addTopBorderToButton(climbingButton)
    }
    
    private func addTopBorderToButton(_ button: UIButton) {
        let topBorderLayer = CALayer()
        topBorderLayer.backgroundColor = UIColor.lineSolidLight.cgColor
        topBorderLayer.frame = CGRect(x: -16, y: 0, width: self.frame.width, height: 1)
        
        button.layer.addSublayer(topBorderLayer)
    }
    
    private func setLayout() {
        [titleLabel, descriptionLabel, climbingButton]
            .forEach { addSubview($0) }
        
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
}
