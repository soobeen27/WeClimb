//
//  ProfileSettingConst.swift
//  WeClimb
//
//  Created by 윤대성 on 2/19/25.
//

import UIKit

enum ProfileSettingConst {
    
    enum Text {
        static let titleProfileLabel: String = "프로필"
        static let nickNameLabel: String = "닉네임"
        static let nickNameRequiredLabel: String = "필수"
        
        static let nickNameTextFieldPlaceholder: String = "닉네임을 입력해주세요"
        
        static let heightLabel: String = "신장"
        static let heightRequierdLabel: String = "필수"
        
        static let heightTextFieldPlaceholder: String = "신장을 입력해주세요"
        
        static let armReachLabel: String = "암리치"
        static let armReachSelectionLabel: String = "선택"
        
        static let armReachTextFieldPlaceholder: String = "암리치를 입력해주세요"
        
        static let activityLabel: String = "활동"
        
        static let confirmButtonLabel: String = "확인"
    }
    
    enum Font {
        static let titleProfileLabelFont: UIFont = UIFont.customFont(style: .caption1SemiBold)
        static let basicFont: UIFont = UIFont.customFont(style: .label2Medium)
        static let valueFont: UIFont = UIFont.customFont(style: .caption1Regular)
        static let textFieldFont: UIFont = UIFont.customFont(style: .body2Medium)
    }
    
    enum Color {
        static let titleLabelBackgroundColor: UIColor = .fillSoildLightNormal
        static let titleLabelColor: UIColor = .labelStrong
        static let basicLabelColor: UIColor = .labelNormal
        static let valueLabelColor: UIColor = .labelNeutral
        static let confirmButtonColor: UIColor = UIColor.fillSolidDarkBlack
        static let textFieldBorderColor: UIColor = .lineOpacityNormal
        static let textFieldFontColor: UIColor = .labelAssistive
    }
    
    enum Image {
        static let nonImage: UIImage? = UIImage.nonpicture
            .resize(targetSize: CGSize(width: Size.profileImage, height: Size.profileImage))
    }
    
    enum Spacing {
        static let stackViewSpacing: CGFloat = 4
        static let confirmButtonBottomOffset: CGFloat = 20
    }
    
    enum CornerRadius {
        static let profileImageCornerRadius: CGFloat = 40
        static let textFieldCornerRadius: CGFloat = 8
        static let confirmButtonCornerRadius: CGFloat = 8
    }
    
    enum Size {
        static let profileImage: CGFloat = 80
        static let confirmButtonHeight: CGFloat = 50
        static let textFieldBorderWidth: CGFloat = 1
    }
}
