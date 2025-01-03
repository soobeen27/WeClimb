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
    
    enum PrivacyPolicy {
        enum Color {
            static let titleTextColor: UIColor = UIColor.labelStrong
            static let pageControlTextColor: UIColor = UIColor.fillSolidLightNormal
            static let CheckBoxFontColor: UIColor = UIColor.labelNormal
            static let containerBoxColor: UIColor = UIColor.fillSolidLightLight
        }
        
        enum Text {
            static let titleLabel = "이용 약관에\n동의해 주세요"
            static let pageControl = "1/3"
            static let isAllAgree = "모두 동의"
            static let nextPage = "다음"
            static let titleNumberofLine = 2
            
            static let isAppTermsAgreed = " (필수) WeClimb 이용약관"
            static let isPrivacyTermsAgreed = " (필수) WeClimb 개인정보 수집 및 이용에 대한 동의"
            static let isSNSConsenctGivenCheck = " (선택) SNS 광고성 정보 수신동의"
            
            static let termsText = "이용약관\n개인정보 처리방침"
            static let termsRange = "이용약관"
            static let privacyPolicyRange = "개인정보 처리방침"
        }
        
        enum Size {
            
        }
        
        enum Font {
            static let titleFont = UIFont.customFont(style: CustomFontStyle.title1Bold)
            static let pageControlFont = UIFont.customFont(style: CustomFontStyle.caption1Regular)
            static let titleCheckBoxFont = UIFont.customFont(style: CustomFontStyle.label1Medium)
            static let valueCheckBoxFont = UIFont.customFont(style: CustomFontStyle.label2Medium)
        }
        
        enum Spacing {
//            static let 
        }
        
        enum Image {
            static let weclimbLogo: UIImage = UIImage.logo
            static let clickCheckBox: UIImage = UIImage.privacyPolicyCheck
            static let clearCheckBox: UIImage = UIImage.privacyPolicyNonCheck
        }
        
        enum link {
            static let termslink = "https://www.notion.so/iosclimber/104292bf48c947b2b3b7a8cacdf1d130"
            static let privacyPolicylink = "https://www.notion.so/iosclimber/146cdb8937944e18a0e055c892c52928"
        }
        
        enum Style {
            static let pageControlCornerRadius = 10000
            static let containerCornerRadius: CGFloat = 14
        }
    }
}
