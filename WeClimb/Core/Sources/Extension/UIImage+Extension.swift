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
        
        case serach
        case serachFill
        
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
        case .serach:
            imageName = "searchIcon"
        case .serachFill:
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
        }
        return UIImage(named: imageName)
    }
}

