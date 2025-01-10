//
//  FeedConts.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/7/25.
//
import UIKit

enum FeedConsts {
    enum CollectionView {
        static let lineSpacing: CGFloat = 0
        static let backgroundColor: UIColor = .clear
    }
    enum Profile {
        enum Size {
            static let profileImageSize: CGFloat = 36
            static let profileImageCornerRadius = profileImageSize / 2
            static let tagCornerRadius: CGFloat = 8
            static let tagHeight: CGFloat = 26
            static let tagHPadding: CGFloat = 9
            static let tagImage: CGSize = CGSize(width: 12, height: 12)
            static let tagSpacing: CGFloat = 4
        }
        enum Font {
            static let name: UIFont = UIFont.customFont(style: .label2SemiBold)
            static let userInfo: UIFont = UIFont.customFont(style: .caption2Regular)
            static let tag: UIFont = UIFont.customFont(style: .caption1Medium)
            static let caption: UIFont = UIFont.customFont(style: .body2Regular)
        }
        enum Color {
            static let text: UIColor = UIColor.labelWhite
            static let tagBackground: UIColor = UIColor.fillOpacityLightStrong
            static let locationTint: UIColor = UIColor.staticWhite
        }
        enum Image {
            static let locaction: UIImage = UIImage.locationIconFill
        }
    }
}
