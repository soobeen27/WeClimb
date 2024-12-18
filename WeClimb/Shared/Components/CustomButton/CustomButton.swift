//
//  twoImageButton.swift
//  WeClimb
//
//  Created by 강유정 on 12/18/24.
//

import UIKit

import SnapKit

class CustomButton: UIButton {
    
    var leftImage: UIImage? {
        didSet {
            updateButtonImages()
        }
    }
    
    var rightImage: UIImage? {
        didSet {
            updateButtonImages()
        }
    }
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setButton() {
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func setLayout() {
        [leftImageView, rightImageView]
            .forEach { addSubview($0) }

        guard let titleLabel = titleLabel else { return }
        
        leftImageView.snp.makeConstraints { make in
            make.trailing.equalTo(titleLabel.snp.leading).offset(-6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func updateButtonImages() {
        leftImageView.image = leftImage
        rightImageView.image = rightImage
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 136, height: 48)
    }
}
