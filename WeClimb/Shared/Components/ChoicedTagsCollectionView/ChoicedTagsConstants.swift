//
//  ChoicedTagsConstants.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/27/24.
//
import UIKit

enum ChoicedTagsConstants {
    enum Color {
        static let collectionViewBackgroundColor: UIColor = UIColor.fillSolidLightNormal
        static let cellBackgroundColor: UIColor = UIColor.fillSolidLightWhite
        static let closeImageTintColor: UIColor = UIColor.labelAlternative
        static let checkImageTintColor: UIColor = UIColor.labelWhite
    }
    
    enum Font {
        static let tagTitle: UIFont = UIFont.customFont(style: .label2SemiBold)
    }
    
    enum Image {
        static let closeButtonImage: UIImage = UIImage.closeIcon
        static let checkImage: UIImage = UIImage.checkIcon
        static func colorImage(color: ColorType) -> UIImage {
            return UIImage.colors(style: color)
        }
    }
    
    enum Size {
        static let height: CGFloat = 33.adjustedH
        static let cornerRadius: CGFloat = height / 2
        
        static let leftImageViewSize: CGSize = CGSize(width: 16.adjusted, height: 16.adjusted)
        static let cancelButtonSize: CGSize = CGSize(width: 16.adjusted, height: 16.adjusted)
    }
    
    enum Spacing {
        static let items: CGFloat = 6.adjusted
        static let horizontal: CGFloat = 10.adjustedH
        static let vertical: CGFloat = 8.adjusted
    }
    
    enum Text {
        static let removeAll = "모두 지우기"
    }
}
