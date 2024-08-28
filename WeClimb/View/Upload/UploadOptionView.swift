//
//  UploadOptionView.swift
//  WeClimb
//
//  Created by Soo Jang on 8/28/24.
//

import UIKit

import SnapKit

class UploadOptionView : UIView {
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "figure.climbing")
        imageView.tintColor = .label
        return imageView
    }()
    
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.text = UploadNameSpace.gym
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let selectedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "test"
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let greaterThanSign: UILabel = {
        let label = UILabel()
        label.text = UploadNameSpace.greaterThan
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 41)
    }

    private func setLayout() {
        self.backgroundColor = .systemBackground
        [symbolImageView, optionLabel, greaterThanSign, selectedLabel]
            .forEach {
                self.addSubview($0)
            }
        
        symbolImageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        
        optionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(symbolImageView.snp.trailing).offset(8)
        }
        
        greaterThanSign.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        selectedLabel.snp.makeConstraints {
            $0.trailing.equalTo(greaterThanSign.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(symbolImage: UIImage, option: String, selected: String) {
        symbolImageView.image = symbolImage
        optionLabel.text = option
        selectedLabel.text = selected
    }
}
