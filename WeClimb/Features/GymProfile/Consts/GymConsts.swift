//
//  GymConsts.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/18/25.
//
import UIKit

enum GymConsts {
    enum Profile {
        enum Color {
            static let background: UIColor = UIColor.fillSolidLightWhite
        }
    }
    
    enum FilterButton {
        enum Size {
            static let width: CGFloat = 76
            static let height: CGFloat = 33
            static let leadingPadding: CGFloat = 12
            static let trailingPadding: CGFloat = 10
            static let hPadding: CGFloat = 6
            static let spacing: CGFloat = 4
            static let cornerRadius: CGFloat = height / 2
            static let image: CGFloat = 16
            static let strokeWidth: CGFloat = 1
        }
        enum Font {
            static let title: UIFont = UIFont.customFont(style: .label2Regular)
            static let selectedTitle: UIFont = UIFont.customFont(style: .label2SemiBold)
        }
        enum Color {
            static let title: UIColor = UIColor.labelNeutral
            static let selectedTitle: UIColor = UIColor.labelStrong
            static let background: UIColor = UIColor.fillSolidLightLight
            static let selectedBackground: UIColor = UIColor.fillSoildLightNormal
            static let stroke: UIColor = UIColor.lineSolidLight
        }
        enum Image {
            static let chevDown: UIImage? = UIImage.chevronDownIcon.resize(targetSize: CGSize(width: Size.image, height: Size.image))?.withTintColor(Color.title)
        }
        enum Text {
            static let level = "난이도"
            static let hold = "홀드"
            static let filter = "Filter"
        }
    }
    
    enum BasicInfoView {
        enum Size {
            static let padding: CGFloat = 16
            static let imageNameSpacing: CGFloat = 12
            static let imageSize: CGSize = CGSize(width: 80, height: 80)
            static let imageCornerRadius: CGFloat = imageSize.height / 2
            static let nameAddresssSpacing: CGFloat = 4
        }
        enum Color {
            static let address: UIColor = UIColor.labelNeutral
            static let name: UIColor = UIColor.labelStrong
            static let border: UIColor = UIColor.lineSolidLight
        }
        enum Font {
            static let address: UIFont = UIFont.customFont(style: .label2Regular)
            static let name: UIFont = UIFont.customFont(style: .heading2SemiBold)
        }
    }
}
