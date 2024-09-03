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
    
    private let greaterThanSign: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "greaterthan")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    private let seperatorLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .secondarySystemBackground
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
        return CGSize(width: UIView.noIntrinsicMetric, height: 57)
    }

    private func setLayout() {
        self.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        [symbolImageView, seperatorLine, optionLabel, greaterThanSign, selectedLabel]
            .forEach {
                self.addSubview($0)
            }
        
        seperatorLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        symbolImageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(16)
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
            $0.size.equalTo(30)
        }
    }
    
    func configure(symbolImage: UIImage, option: String, selected: String) {
        symbolImageView.image = symbolImage
        optionLabel.text = option
        selectedLabel.text = selected
    }
}
