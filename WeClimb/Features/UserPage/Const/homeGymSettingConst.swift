//
//  homeGymSettingConst.swift
//  WeClimb
//
//  Created by 윤대성 on 2/21/25.
//

import UIKit

enum homeGymSettingConst {
    
    enum Text {
        static let searchBarLabel = "검색하기"
        static let favoriteLabel = "즐겨찾기"
        static let placeholderText = "검색하기"
    }
    
    enum Color {
        static let titleColor = UIColor.labelStrong
        static let placeholderBorderColor = UIColor.lineOpacityNormal
        static let placeholderFontColor = UIColor.labelAssistive
    }
    
    enum Font {
        static let titleFont = UIFont.customFont(style: .label1SemiBold)
        static let placeholderFont = UIFont.customFont(style: .body2Medium)
    }
    
    enum Spacing {

    }
    
    enum Size {
        static let placeholderHeight: CGFloat = 46
    }
    
    enum CornerRadius {
        
    }
    
    enum Image {
        static let locaction: UIImage? =
        UIImage.locationIconFill.resize(targetSize: BadgeConst.Size.badgeImage)?
            .withTintColor(BadgeConst.Color.text)
    }
}

