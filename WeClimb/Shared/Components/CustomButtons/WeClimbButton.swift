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
    
    var buttonSize: WeClimbButtonConst.IconRectangleSize = .medium {
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
        imageView.tintColor = WeClimbButtonConst.Color.defaultBackgroundColor
        return imageView
    }()
    
    private lazy var rightIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = WeClimbButtonConst.Color.defaultTintColor
        return imageView
    }()
    
    init(style: ButtonStyle, size: WeClimbButtonConst.IconRectangleSize = .medium) {
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
            return CGSize(width: WeClimbButtonConst.DefaultRectangle.Size.width, height: WeClimbButtonConst.DefaultRectangle.Size.height)
        case .iconRectangle:
            let textWidth = titleLabel?.intrinsicContentSize.width ?? WeClimbButtonConst.IconRectangleSize.Layout.defaultWidth
            let totalWidth = buttonSize.icon * WeClimbButtonConst.IconRectangleSize.Layout.iconCount + textWidth + buttonSize.spacing * WeClimbButtonConst.IconRectangleSize.Layout.spacingCount + buttonSize.padding * WeClimbButtonConst.IconRectangleSize.Layout.paddingCount
            return CGSize(width: totalWidth, height: buttonSize.height)
            
        case .rightIconRound:
            return CGSize(width: WeClimbButtonConst.RightIconRound.Size.width, height:  WeClimbButtonConst.RightIconRound.Size.height)
        }
    }
    
    private func setButtonStyle(_ style: ButtonStyle) {
        switch style {
        case .defaultRectangle:
            layer.cornerRadius = WeClimbButtonConst.DefaultRectangle.cornerRadius
            clipsToBounds = true
            titleLabel?.font = UIFont.customFont(style: .label1SemiBold)
            setTitleColor(WeClimbButtonConst.Color.defaultTitleColor, for: .normal)
            backgroundColor = WeClimbButtonConst.Color.defaultBackgroundColor
            
        case .iconRectangle:
            layer.cornerRadius = buttonSize.cornerRadius
            clipsToBounds = true
            titleLabel?.font = buttonSize.fontType
            setTitleColor(WeClimbButtonConst.Color.defaultTitleColor, for: .normal)
            backgroundColor = WeClimbButtonConst.Color.defaultBackgroundColor
            
        case .rightIconRound:
            layer.cornerRadius = WeClimbButtonConst.RightIconRound.cornerRadius
            clipsToBounds = true
            titleLabel?.font = UIFont.customFont(style: .caption1Medium)
            setTitleColor(WeClimbButtonConst.Color.defaultTitleColor, for: .normal)
            backgroundColor = WeClimbButtonConst.Color.defaultBackgroundColor
        }
    }
    
    private func setLayout() {
        guard let titleLabel else { return }
        
        [leftIconView, rightIconView]
            .forEach{ addSubview($0) }
        
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
                $0.trailing.equalToSuperview().offset(-WeClimbButtonConst.RightIconRound.Spacing.rightPadding)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(WeClimbButtonConst.RightIconRound.Size.imageSize)
            }
            
            titleLabel.snp.makeConstraints {
                $0.trailing.equalTo(rightIconView.snp.leading).offset(-WeClimbButtonConst.RightIconRound.Spacing.spacing)
                $0.leading.equalToSuperview().offset(WeClimbButtonConst.RightIconRound.Spacing.leftPadding)
            }
        }
    }
    
    private func updateIconImages() {
        leftIconView.image = leftIcon
        rightIconView.image = rightIcon
    }
}
