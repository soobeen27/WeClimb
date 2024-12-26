//
//  twoImageButton.swift
//  WeClimb
//
//  Created by 강유정 on 12/18/24.
//

import UIKit

import SnapKit

class RectangleIconButton: UIButton {
    
    var buttonSize: RectangleButtonSize = .medium {
        didSet {
            setNeedsLayout()
        }
    }
    
    var leftIcon: UIImage? {
        didSet {
            updateIconImages()
        }
    }
    
    var rightIcon: UIImage? {
        didSet {
            updateIconImages()
        }
    }
    
    private lazy var leftIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var rightIconView: UIImageView = {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.font = buttonSize.fontType
    }
    
    override var intrinsicContentSize: CGSize {
        let textWidth = titleLabel?.intrinsicContentSize.width ?? 0
        let totalWidth = buttonSize.iconSize * 2 + textWidth + buttonSize.interval * 2 + buttonSize.padding * 2
        return CGSize(width: totalWidth, height: buttonSize.height)
    }
    
    private func setButton() {
        layer.cornerRadius = buttonSize.cornerRadius
        clipsToBounds = true
    }
    
    private func setLayout() {
        [leftIconView, rightIconView].forEach { addSubview($0) }
        
        guard let titleLabel = titleLabel else { return }
        
        leftIconView.snp.makeConstraints { make in
            make.trailing.equalTo(titleLabel.snp.leading).offset(-buttonSize.interval)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(buttonSize.iconSize)
        }
        
        rightIconView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(buttonSize.interval)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(buttonSize.iconSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func updateIconImages() {
        leftIconView.image = leftIcon
        rightIconView.image = rightIcon
    }
}
