//
//  FeedConsts.swift
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
            static let spacing: CGFloat = 12
            static let padding: CGFloat = 16
            static let userNameProfileImageSpacing: CGFloat = 8
            static let userNameHeightSpacing: CGFloat = 2
            static let tagsViewWSpacing: CGFloat = 4
            static let tagsViewHSpacing: CGFloat = 8
            static let captionShortHeight: CGFloat = 44
            static let captionLongHeight: CGFloat = 400
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
            static let locaction: UIImage? =
            UIImage.locationIconFill.resize(targetSize: FeedConsts.Profile.Size.tagImage)?
                .withTintColor(FeedConsts.Profile.Color.text)
            
            static let show: UIImage? =
            UIImage.chevronDownIcon.resize(targetSize: CGSize(width: 24, height: 24))?
                .withTintColor(FeedConsts.Profile.Color.text)
            
            static let hide: UIImage? =
            UIImage.chevronUpIcon.resize(targetSize: CGSize(width: 24, height: 24))?
                .withTintColor(FeedConsts.Profile.Color.text)
        }
        
        enum Text {
            static let level: String = "레벨"
            static let hold: String = "홀드"
        }
    }
}
