//
//  homeGymSettingConst.swift
//  WeClimb
//
//  Created by 윤대성 on 2/21/25.
//

import UIKit

enum homeGymSettingConst {
    
    enum Text {
        static let favoriteLabel = "즐겨찾기"
        static let placeholderText = "검색하기"
    }
    
    enum Color {
        static let titleColor = UIColor.labelStrong
        static let placeholderBorderColor = UIColor.lineOpacityNormal
        static let placeholderFontColor = UIColor.labelAssistive
        static let locaction: UIColor = UIColor.labelWhite
        static let basicMarkColor: UIColor = UIColor.labelAssistive
    }
    
    enum Font {
        static let titleFont = UIFont.customFont(style: .label1SemiBold)
        static let placeholderFont = UIFont.customFont(style: .body2Medium)
    }
    
    enum Spacing {

    }
    
    enum Size {
        static let placeholderHeight: CGFloat = 46
        static let homeGymMarkSize: CGSize = CGSize(width: 13, height: 17)
        static let badgeImage: CGSize = CGSize(width: 12, height: 12)
    }
    
    enum CornerRadius {
        
    }
    
    enum Image {
        static let locaction: UIImage? =
        UIImage.locationIconFill.resize(targetSize: Size.badgeImage)?
            .withTintColor(Color.locaction)
        
        static let nomalHomeGymMark: UIImage? =
        UIImage.homeIcon.resize(targetSize: Size.homeGymMarkSize)?
            .withTintColor(Color.basicMarkColor)
        
        static let clickHomeGymMark: UIImage? =
        UIImage.homeBadge.resize(targetSize: Size.homeGymMarkSize)
    }
}

