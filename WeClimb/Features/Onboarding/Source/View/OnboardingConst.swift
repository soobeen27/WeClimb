//
//  OnboardingConstants.swift
//  WeClimb
//
//  Created by 윤대성 on 12/31/24.
//

import UIKit

enum OnboardingConst {
    
    static let weclimbLogo: UIImage = UIImage.logo
    
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
            static let checkBoxFontColor: UIColor = UIColor.labelNormal
            static let containerBoxColor: UIColor = UIColor.fillSolidLightLight
            static let confirmActivationColor: UIColor = UIColor.labelAlternative
            static let confirmDeactivationColor: UIColor = UIColor.fillSolidDarkBlack
        }
        
        enum Text {
            static let titleLabel = "이용 약관에\n동의해주세요"
            static let pageControl = "1/3"
            static let isAllAgree = "전체 동의"
            static let nextPage = "다음"
            static let titleNumberofLine = 2
            
            static let isAppTermsAgreed = "WeClimb 이용약관(필수)"
            static let isPrivacyTermsAgreed = "개인정보 수집 및 이용에 대한 동의(필수)"
            static let isSNSConsenctGivenCheck = "SNS 광고성 정보 수신동의(선택)"
            
            static let AppTermAgreedButtonText = "이용약관"
            static let PrivacyTermsAgreedLinkButton = "개인정보보호방침"
        }
        
        enum Font {
            static let titleFont = UIFont.customFont(style: CustomFontStyle.title1Bold)
            static let valueFont = UIFont.customFont(style: CustomFontStyle.caption1Regular)
            static let titleCheckBoxFont = UIFont.customFont(style: CustomFontStyle.label1Medium)
            static let valueCheckBoxFont = UIFont.customFont(style: CustomFontStyle.label2Medium)
        }
        
        enum CornerRadius {
            static let pageControl: CGFloat = 16
            static let confirmButton: CGFloat = 8
        }
        
        enum Size {
            static let logoSize: CGSize = CGSize(width: 60, height: 60)
            static let pageControllerSize: CGSize = CGSize(width: 41, height: 26)
            static let checkBoxBackGroundSize: CGSize = CGSize(width: 343, height: 127)
            static let AppTermsLinkButtonSize: CGSize = CGSize(width: 42, height: 16)
            static let PrivacyTermsLinkButtonSize: CGSize = CGSize(width: 83, height: 16)
            static let checkBoxHeight: CGFloat = 21
            static let allAgreeCheckBoxHeight: CGFloat = 48
            static let confirmButtonHeight: CGFloat = 50
            static let labelstartLocation = 0
        }
        
        enum Style {
            static let containerCornerRadius: CGFloat = 8
            static let confirmButtonCornerRadius: CGFloat = 8
            static let pageControlCornerRadius = 10000
        }
        
        enum Spacing {
            static let pageControllerTopOffset: CGFloat = 0
            static let logoTopOffset: CGFloat = 30
            static let titleLabelTopOffset: CGFloat = 16
            static let allAgreeCheckBoxTopOffset: CGFloat = 40
            static let checkBoxBackgroundViewTopOffset: CGFloat = 0
            static let checkBoxVerticalSpacing: CGFloat = 16
            static let linkButtonTopOffset: CGFloat = 16
            static let linkButtonVerticalSpacing: CGFloat = 8
            static let privacyPolicyLabelLeadingOffset: CGFloat = 32
            static let confirmButtonBottomOffset: CGFloat = 20
            static let horizontalPadding: CGFloat = 16
            static let checkBoxBackgroundViewHeight: CGFloat = 127
        }
        
        enum Image {
            static let clickCheckBox: UIImage = UIImage.privacyPolicyCheck
            static let clearCheckBox: UIImage = UIImage.privacyPolicyNonCheck
        }
        
        enum link {
            static let termslink = "https://www.notion.so/iosclimber/104292bf48c947b2b3b7a8cacdf1d130"
            static let privacyPolicylink = "https://www.notion.so/iosclimber/146cdb8937944e18a0e055c892c52928"
        }
    }
    
    enum CreateNickname {
        enum Color {
            static let titleTextColor: UIColor = UIColor.labelStrong
            static let subtitleTextColor: UIColor = UIColor.labelNeutral
            static let pageControlTextColor: UIColor = UIColor.fillSolidLightNormal
            static let nickNameFieldColor: UIColor = UIColor.labelAssistive
            static let nickNameLabelColor: UIColor = UIColor.labelNormal
            static let backgroundColor: UIColor = UIColor.white
            static let boarderGray: UIColor = UIColor.lineOpacityNormal
            static let errorTextColor: UIColor = UIColor.statusNegative
            static let confirmActivationColor: UIColor = UIColor.labelAlternative
            static let confirmDeactivationColor: UIColor = UIColor.fillSolidDarkBlack
        }
        
        enum Text {
            static let titleLabel = "닉네임을\n설정해주세요"
            static let pageControl = "2/3"
            static let titleNumberofLine = 2
            
            static let nickNameTitle = "닉네임"
            static let nickNameSub = "필수"
            
            static let nicknamePlaceholder = "닉네임을 입력해주세요"
            static let charCountLabel = "0/12"
            static let errorMessageDuplicate = "이미 사용중인 닉네임입니다."
            static let errorMessage = "알 수 없는 오류가 발생하셨습니다."
            
            static let regex = "^[가-힣a-zA-Z0-9]{2,12}$"
            static let nextPage = "다음"
        }
        
        enum Font {
            static let titleFont = UIFont.customFont(style: CustomFontStyle.title1Bold)
            static let valueFont = UIFont.customFont(style: CustomFontStyle.caption1Regular)
            
            static let nickNameTitle = UIFont.customFont(style: CustomFontStyle.label2Medium)
            static let placeholderFont = UIFont.customFont(style: CustomFontStyle.body2Medium)
        }
        
        enum Icon {
            static let chevronRight = UIImage(systemName: "chevron.right")
            static let xCircle = UIImage(systemName: "x.circle")
            static let exclamationMark = UIImage(systemName: "exclamationmark.circle")
        }
        
        enum CornerRadius {
            static let pageControl: CGFloat = 16
            static let textField: CGFloat = 8
            static let button: CGFloat = 8
            static let confirmButton: CGFloat = 8
        }
        
        enum Spacing {
            static let stackViewSpacing: CGFloat = 3
            static let textFieldTopOffset: CGFloat = 8
            static let labelTopOffset: CGFloat = 4
            static let confirmButtonBottomOffset: CGFloat = 20
            static let viewHorizontalMargin: CGFloat = 16
            static let logoTopMargin: CGFloat = 30
            static let nicknameTextFieldTop: CGFloat = 32
        }
        
        enum Size {
            static let logoSize: CGSize = CGSize(width: 60, height: 60)
            static let pageControlSize: CGSize = CGSize(width: 41, height: 26)
            static let iconSize: CGSize = CGSize(width: 16, height: 16)
            static let nickNameTilteStackViewSize: CGSize = CGSize(width: 62, height: 21)
            static let nickNameTitleLabelSize: CGSize = CGSize(width: 37, height: 21)
            static let nickNameSubTitleLabelSize: CGSize = CGSize(width: 21, height: 16)
            static let characterCountLabelSize: CGSize = CGSize(width: 30, height: 16)
            
            static let textFieldHeight: CGFloat = 46
            static let errorMessageHeight: CGFloat = 21
            static let characterCountLabelWidth: CGFloat = 30
            static let characterCountLabelHeight: CGFloat = 16
            static let confirmButtonHeight: CGFloat = 50
            static let borderWidth: CGFloat = 1
            static let minCharacterCount: Int = 2
            static let maxCharacterCount: Int = 12
        }
        
        enum Status {
            static let boolValue: Int = 0
            static let trueValue: Int = 1
        }
    }
    
    enum PersonalDetail {
        enum Text {
            static let titleLabel = "신체 정보를\n입력해주세요"
            static let titleNumberofLine = 2
            static let pageControl = "3/3"
            static let nextPage = "다음"
            
            static let heightTitleText = "신장"
            static let armrichTitleText = "암리치"
            
            static let requiredText = "필수"
            static let selectionLabel = "선택"
            
            static let heightTitle = "신장"
            static let armrichTitle = "암리치"
            
            static let heightPlaceholder = "신장을 입력해주세요"
            static let armrichPlaceholder = "리치를 입력해주세요"
            
        }
        
        enum CornerRadius {
            static let pageControl: CGFloat = 16
            static let textFieldCornerRadius: CGFloat = 8
            static let confirmButton: CGFloat = 8
        }
        
        enum Spacing {
            static let viewHorizontalMargin: CGFloat = 16
            static let stackViewSpacing: CGFloat = 3
            static let logoTopSpacing: CGFloat = 30
            static let titleTopSpacing: CGFloat = 16
            static let textFieldTopSpacing: CGFloat = 8
            static let titleStackViewTopSpacing: CGFloat = 32
            static let confirmButtonBottomSpacing: CGFloat = 20
        }
        
        enum Font {
            static let titleFont = UIFont.customFont(style: CustomFontStyle.title1Bold)
            static let valueFont = UIFont.customFont(style: CustomFontStyle.caption1Regular)
            static let textFiledTitleLabelFont = UIFont.customFont(style: CustomFontStyle.label2Medium)
            static let placeholderFont = UIFont.customFont(style: CustomFontStyle.body2Medium)
        }
        
        enum Color {
            static let titleTextColor: UIColor = UIColor.labelStrong
            static let pageControlTextColor: UIColor = UIColor.fillSolidLightNormal
            static let subtitleTextColor: UIColor = UIColor.labelNeutral
            static let textFieldLabelColor: UIColor = UIColor.labelNormal
            static let backgroundColor: UIColor = UIColor.white
            static let boarderGray: UIColor = UIColor.lineOpacityNormal
            static let placeholderTextFieldColor: UIColor = UIColor.labelAssistive
            static let confirmActivationColor: UIColor = UIColor.labelAlternative
        }
        
        enum Size {
            static let textFieldBorderWidth: CGFloat = 1
            static let logoSize: CGSize = CGSize(width: 60, height: 60)
            static let pageControlSize: CGSize = CGSize(width: 41, height: 26)
            static let heightTitleStackViewSize: CGSize = CGSize(width: 50, height: 21)
            static let heightTitleLabelSize: CGSize = CGSize(width: 25, height: 21)
            static let requiredLabelSize: CGSize = CGSize(width: 21, height: 16)
            static let armrichTitleStackViewSize: CGSize = CGSize(width: 62, height: 21)
            static let armrichTitleLabelSize: CGSize = CGSize(width: 37, height: 21)
            static let selectionLabelSize: CGSize = CGSize(width: 21, height: 16)
            
            static let heightTextFieldHeight: CGFloat = 46
            static let armrichTextFieldHeight: CGFloat = 46
        }
    }
    
    enum RegisterResult {
        enum Text {
            static let titleLabel = "가입이\n완료되었어요!"
            static let titleNumberofLine = 2
            
            static let GreetingComment = "위클에 오신 것을 진심으로 환영합니다!"
            static let confirmText = "시작"
        }
        
        enum Font {
            static let titleFont = UIFont.customFont(style: CustomFontStyle.title1Bold)
            static let valueFont = UIFont.customFont(style: CustomFontStyle.label2Medium)
        }
        
        enum Color {
            static let titleTextColor: UIColor = UIColor.labelStrong
            static let greetingCommentColor: UIColor = UIColor.labelNormal
            static let confirmColor: UIColor = UIColor.primaryStrong
        }
        
        enum CornerRadius {
            static let confirmButton: CGFloat = 8
        }
        
        enum Size {
            static let logoSize: CGSize = CGSize(width: 60, height: 60)
        }
        
        enum Spacing {
            static let logoTopSpacing: CGFloat = 30
            static let baseSpacing: CGFloat = 16
            static let commentTopSpacing: CGFloat = 32
            static let confirmBottomSpacing: CGFloat = 20
        }
    }
}
