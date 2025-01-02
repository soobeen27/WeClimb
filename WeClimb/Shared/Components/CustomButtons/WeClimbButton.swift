//
//  WeClimbButton.swift
//  WeClimb
//
//  Created by 강유정 on 12/30/24.
//

import UIKit

class WeClimbButton: UIButton {
    
    enum ButtonStyle {
        case defaultRectangle
        case iconRectangle
        case rightIconRound
    }
    
    var buttonStyle: ButtonStyle {
        didSet {
            setButtonStyle(buttonStyle)
            setNeedsLayout()
        }
    }
    
    var buttonSize: ButtonsConst.IconRectangleSize = .medium {
        didSet {
            setButtonStyle(buttonStyle)
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
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var rightIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    init(style: ButtonStyle, size: ButtonsConst.IconRectangleSize = .medium) {
        self.buttonStyle = style
        self.buttonSize = size
        super.init(frame: .zero)
        setButtonStyle(style)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        switch buttonStyle {
        case .defaultRectangle:
            return CGSize(width: 343, height: 48)
        case .iconRectangle:
            let textWidth = titleLabel?.intrinsicContentSize.width ?? 0
            let totalWidth = buttonSize.icon * 2 + textWidth + buttonSize.spacing * 2 + buttonSize.padding * 2
            return CGSize(width: totalWidth, height: buttonSize.height)
            
        case .rightIconRound:
            return CGSize(width: RoundRightIconButtonNS.width, height: RoundRightIconButtonNS.height)
        }
    }
    
    private func setButtonStyle(_ style: ButtonStyle) {
        switch style {
        case .defaultRectangle:
            layer.cornerRadius = 10
            clipsToBounds = true
            titleLabel?.font = UIFont.customFont(style: .label1SemiBold)
            setTitleColor(.white, for: .normal)
            backgroundColor = .black
            
        case .iconRectangle:
            layer.cornerRadius = buttonSize.cornerRadius
            clipsToBounds = true
            titleLabel?.font = buttonSize.fontType
            setTitleColor(.white, for: .normal)
            backgroundColor = .black
            
        case .rightIconRound:
            layer.cornerRadius = RoundRightIconButtonNS.cornerRadius
            clipsToBounds = true
            titleLabel?.font = UIFont.customFont(style: .caption1Medium)
            setTitleColor(.white, for: .normal)
            backgroundColor = .black
        }
    }
    
    private func setLayout() {
        addSubview(leftIconView)
        addSubview(rightIconView)
        
        guard let titleLabel else { return }
        
        switch buttonStyle {
        case .defaultRectangle:
            titleLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
        case .iconRectangle:
            leftIconView.snp.makeConstraints {
                $0.trailing.equalTo(titleLabel.snp.leading).offset(-buttonSize.spacing)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(buttonSize.icon)
            }
            
            rightIconView.snp.makeConstraints {
                $0.leading.equalTo(titleLabel.snp.trailing).offset(buttonSize.spacing)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(buttonSize.icon)
            }
            
            titleLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
        case .rightIconRound:
            rightIconView.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-RoundRightIconButtonNS.trailing)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(RoundRightIconButtonNS.imageSize)
            }
            
            titleLabel.snp.makeConstraints {
                $0.trailing.equalTo(rightIconView.snp.leading).offset(-RoundRightIconButtonNS.inteval)
                $0.leading.equalToSuperview().offset(RoundRightIconButtonNS.leading)
            }
        }
    }
    
    private func updateIconImages() {
        leftIconView.image = leftIcon
        rightIconView.image = rightIcon
    }
}
