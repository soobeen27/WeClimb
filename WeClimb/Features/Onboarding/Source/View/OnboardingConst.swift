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
            static let successLoginText = "정상적으로 로그인 되었어요!"
            static let failureLoginText = "로그인에 실패 했어요:"
            static let noVC = "VC가 nil이예요!"
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
            static let titleLabel = "이용 약관에\n동의해주세요"
            static let pageControl = "1/3"
            static let isAllAgree = "모두 동의"
            static let nextPage = "다음"
            static let titleNumberofLine = 2
            
            static let isAppTermsAgreed = "WeClimb 이용약관(필수)"
            static let isPrivacyTermsAgreed = "개인정보 수집 및 이용에 대한 동의(필수)"
            static let isSNSConsenctGivenCheck = "SNS 광고성 정보 수신동의(선택)"
            
            static let AppTermAgreedButtonText = "이용약관"
            static let PrivacyTermsAgreedLinkButton = "개인정보보호방침"
        }
        
        enum Size {
            
        }
        
        enum Font {
            static let titleFont = UIFont.customFont(style: CustomFontStyle.title1Bold)
            static let valueFont = UIFont.customFont(style: CustomFontStyle.caption1Regular)
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
    
    enum CreateNickname {
        enum Color {
            static let titleTextColor: UIColor = UIColor.labelStrong
            static let subtitleTextColor: UIColor = UIColor.labelNeutral
            static let pageControlTextColor: UIColor = UIColor.fillSolidLightNormal
            static let nickNameFieldColor: UIColor = UIColor.labelAssistive
            static let nickNameLabelColor: UIColor = UIColor.black
            static let backgroundColor: UIColor = UIColor.white
            static let boarderGray: UIColor = UIColor.textFieldBorderGray
        }
        
        enum Text {
            static let titleLabel = "닉네임을\n설정해주세요"
            static let pageControl = "2/3"
            static let titleNumberofLine = 2
            
            static let nickNameTitle = "닉네임"
            static let nickNameSub = "필수"
            
            static let nicknamePlaceholder = "닉네임을 입력해주세요"
            static let charCountLabel = "0/12"
        }
        
        enum Font {
            static let titleFont = UIFont.customFont(style: CustomFontStyle.title1Bold)
            static let valueFont = UIFont.customFont(style: CustomFontStyle.caption1Regular)
            
            static let nickNameTitle = UIFont.customFont(style: CustomFontStyle.label2Medium)
            static let placeholderFont = UIFont.customFont(style: CustomFontStyle.body2Medium)
        }
    }
}
