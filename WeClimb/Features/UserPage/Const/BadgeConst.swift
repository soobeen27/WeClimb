//
//  BadgeConst.swift
//  WeClimb
//
//  Created by 윤대성 on 1/24/25.
//

import UIKit

enum BadgeConst {
    
    enum Color {
        static let gymNameBackgroundColor: UIColor = UIColor.fillSolidLightNormal
        static let gymNameMarkerColor: UIColor = UIColor.labelAssistive
        static let gymNameFontColor: UIColor = UIColor.labelNormal
        static let feedBackgroundColor: UIColor = UIColor.fillSolidLightLight
        static let text: UIColor = UIColor.labelWhite
    }
    
    enum Font {
        static let gymNameLabelFont = UIFont.customFont(style: .caption1Medium)
        static let badgeFont = UIFont.customFont(style: .caption1Medium)
    }
    
    enum Spacing {
        static let gymNameMargin: CGFloat = 10
        static let gymNameValueMargin: CGFloat = 6
    }
    
    enum Size {
        static let gymNameMarkerHeight: CGFloat = 12
        static let badgeImage: CGSize = CGSize(width: 12, height: 12)
    }
    
    enum CornerRadius {
        static let badgeViewCornerRadius: CGFloat = 14
    }
    
    enum Image {
        static let locaction: UIImage? =
        UIImage.locationIconFill.resize(targetSize: BadgeConst.Size.badgeImage)?
            .withTintColor(BadgeConst.Color.text)
        
        static let markerImage: UIImage? = UIImage.locationIconFill
            .resize(targetSize: CGSize(width: Size.gymNameMarkerHeight, height: Size.gymNameMarkerHeight))?
            .withTintColor(Color.gymNameMarkerColor, renderingMode: .alwaysOriginal)
    }
}
