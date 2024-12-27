//
//  UIImage+Extension.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import UIKit

extension UIImage {
    /// 지정된 크기로 리사이즈한 새로운 UIImage 객체 반환
    /// - Parameter targetSize: 리사이즈할 목표 크기를 나타내는 CGSize.
    /// - Returns: 리사이즈된 UIImage 객체 반환. (실패시 nil 반환)
    func resize(targetSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    enum CustomImageStyle {
        // MARK: - 탭바 이미지
        case feed
        case feedFill
        
        case search
        case searchFill
        
        case upload
        case uploadFill
        
        case notification
        case notificationFill
        
        case userPage
        case userPageFill
        
        // MARK: - 로그인 페이지
        case loginLogo
        
        case kakaoLogin
        case googleLogin
        case appleLogin
        
        // MARK: - PrivacyPolicy 페이지
        case logoImage
        
        //MARK: - ChoicedTagsCollectionView
        case close
        case check
    }
}

extension UIImage {
    static func customImage(style: CustomImageStyle) -> UIImage? {
        let imageName: String
        
        switch style {
        case .feed:
            imageName = "homeIcon"
        case .feedFill:
            imageName = "homeIcon.fill"
        case .search:
            imageName = "searchIcon"
        case .searchFill:
            imageName = "searchIcon.fill"
        case .upload:
            imageName = "uploadIcon"
        case .uploadFill:
            imageName = "uploadIcon.fill"
        case .notification:
            imageName = "notificationIcon"
        case .notificationFill:
            imageName = "notificationIcon.fill"
        case .userPage:
            imageName = "avatarIcon"
        case .userPageFill:
            imageName = "avatarIcon.fill"
        case .loginLogo:
            imageName = "loginLogo"
        case .kakaoLogin:
            imageName = "kakaoLoginButton"
        case .googleLogin:
            imageName = "googleLoginButton"
        case .appleLogin:
            imageName = "appleLoginButton"
        case .logoImage:
            imageName = "logoImage"
        case .close:
            imageName = "closeIcon"
        case .check:
            imageName = "checkIcon"
        }
        return UIImage(named: imageName)
    }
}

enum ColorType {
    case black
    case blue
    case brown
    case darkBlue
    case darkGreen
    case darkRed
    case darkYellow
    case gray
    case green
    case lightGreen
    case mint
    case navy
    case orange
    case pink
    case purple
    case red
    case white
    case yellow
}

// UIImage Extension
extension UIImage {
    static func colors(style: ColorType) -> UIImage {
        switch style {
        case .black:
            UIImage.colorBlack
        case .blue:
            UIImage.colorBlue
        case .brown:
            UIImage.colorBrown
        case .darkBlue:
            UIImage.colorDarkBlue
        case .darkGreen:
            UIImage.colorDarkGreen
        case .darkRed:
            UIImage.colorDarkRed
        case .darkYellow:
            UIImage.colorDarkYellow
        case .gray:
            UIImage.colorGray
        case .green:
            UIImage.colorGreen
        case .lightGreen:
            UIImage.colorLightGreen
        case .mint:
            UIImage.colorMint
        case .navy:
            UIImage.colorNavy
        case .orange:
            UIImage.colorOrange
        case .pink:
            UIImage.colorPink
        case .purple:
            UIImage.colorPurple
        case .red:
            UIImage.colorRed
        case .white:
            UIImage.colorWhite
        case .yellow:
            UIImage.colorYellow
        }
        
    }
}
