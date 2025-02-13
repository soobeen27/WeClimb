//
//  UserPageConst.swift
//  WeClimb
//
//  Created by 윤대성 on 2/7/25.
//

import UIKit

enum UserPageConst {
    
    enum userInfo {
        enum Font {
            static let userNameLabelFont = UIFont.customFont(style: .heading2SemiBold)
            static let userInfoLabelFont = UIFont.customFont(style: .caption1Regular)
            static let homeGymSettingTextFont = UIFont.customFont(style: .caption1Medium)
        }
        
        enum Color {
            static let userNameLabelColor: UIColor = UIColor.labelStrong
            static let userInfoLabelColor: UIColor = UIColor.labelNeutral
            static let userInfoDoteColor: UIColor = UIColor.labelAssistive
            static let homeGymSettingColor: UIColor = UIColor.labelNormal
            static let userEditButtonColor: UIColor = UIColor.labelNeutral
            static let indicatorBarColor: UIColor = UIColor.lineSolidLight
            static let homeGymSettingSymbolColor: UIColor = UIColor.labelAlternative
            static let homeGymbackgroundColor: UIColor = UIColor.fillSolidLightNormal
        }
        
        enum Text {
            static let dote = "･"
            static let homeGymSettingText: String = "홈짐 설정하기"
            static let editButtonText: String = "편집"
        }
        
        enum Spacing {
            static let userInfoSpacing: CGFloat = 1
        }
        
        enum Size {
            static let symbolSize: CGFloat = 12
            static let profileImageSize: CGFloat = 80
        }
        
        enum Image {
            static let baseImage: UIImage? = UIImage.defaultAvatarProfile
                .resize(targetSize: CGSize(width: Size.profileImageSize, height: Size.profileImageSize))
            
            static let homeImage: UIImage? = UIImage.homeIconFill
                .resize(targetSize: CGSize(width: Size.symbolSize, height: Size.symbolSize))?
                .withTintColor(Color.homeGymSettingSymbolColor, renderingMode: .alwaysOriginal)
            
            static let chevronRightImage: UIImage? = UIImage.chevronRightIcon
                .resize(targetSize: CGSize(width: Size.symbolSize, height: Size.symbolSize))?
                .withTintColor(Color.homeGymSettingSymbolColor, renderingMode: .alwaysOriginal)
        }
    }
    
    enum FeedCell {
        enum Text {
            static let userNameLabelFont = UIFont.customFont(style: .heading2SemiBold)
            static let userNameLabelColor: UIColor = UIColor.labelStrong
            
            
        }
        
        enum Font {
            static let dateLabelFont = UIFont.customFont(style: .caption1Medium)
            static let valueLabelFont = UIFont.customFont(style: .caption1Regular)
            static let captionLabelFont = UIFont.customFont(style: .body2Medium)
        }
        
        enum Color {
            static let dateLabelFontColor: UIColor = UIColor.labelNeutral
            static let symbolColor: UIColor = UIColor.labelAlternative
            static let valueLabelFontColor: UIColor = UIColor.labelAlternative
            static let captionLabelFontColor: UIColor = UIColor.labelNormal
        }
        
        enum Size {
            static let symbolSize: CGFloat = 12
        }
        enum Image {
            static let likeImage: UIImage? = UIImage.heartIcon
                .resize(targetSize: CGSize(width: Size.symbolSize, height: Size.symbolSize))?
                .withTintColor(Color.symbolColor, renderingMode: .alwaysOriginal)
            
            static let commentImage: UIImage? = UIImage.commentIcon
                .resize(targetSize: CGSize(width: Size.symbolSize, height: Size.symbolSize))?
                .withTintColor(Color.symbolColor, renderingMode: .alwaysOriginal)
        }
    }
}
