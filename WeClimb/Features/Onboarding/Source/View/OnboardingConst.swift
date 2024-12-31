//
//  OnboardingConstants.swift
//  WeClimb
//
//  Created by 윤대성 on 12/31/24.
//

import UIKit

enum OnboardingConst {
    enum Login {
        enum Color {
            static let guestLoginFontColor: UIColor = UIColor.labelNeutral
        }
        
        enum Image {
            static let weclimbLogo: UIImage = UIImage.loginLogo
            static let kakaoLoginButton: UIImage = UIImage.kakaoLoginButton
            static let googleLoginButton: UIImage = UIImage.googleLoginButton
            static let appleLoginButton: UIImage = UIImage.appleLoginButton
        }
        
        enum Font {
            static let guestLogin: UIFont = UIFont.customFont(style: CustomFontStyle.caption1Regular)
        }
        
        enum Size {
            static let weclimbLogo: CGSize = CGSize(width: 135, height: 169)
            static let loginButton: CGSize = CGSize(width: 343, height: 48)
        }
        
        enum Spacing {
            static let vertical: CGFloat = 16
            static let logoTopMargin: CGFloat = 48
            
            static let BottomOffset: CGFloat = 0.85
            static let padding: CGFloat = 16
        }
        
        enum Text {
            static let nonMemberButton = "비회원으로 둘러보기"
        }
    }
}
