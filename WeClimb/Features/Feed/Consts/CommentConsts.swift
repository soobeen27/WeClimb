//
//  CommentConsts.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/4/25.
//
import UIKit

enum CommentConsts {
    
    static let strokeColor: UIColor = UIColor.lineSolidLight
    static let strokeHeight: CGFloat = 1
    static let titleText: String = "댓글"
    
    enum TextFieldView {
        enum Size {
            static let height: CGFloat = 112
            static let padding: CGFloat = 16
            static let tfHeight: CGFloat = 48
            static let tfPadding: CGFloat = 12
            static let tfCornerRadius: CGFloat = 8
        }
        enum Font {
            static let placeholder: UIFont = UIFont.customFont(style: .body2Medium)
        }
        
        enum Color {
            static let placeholder: UIColor = UIColor.labelAssistive
            static let background: UIColor = UIColor.fillSolidLightLight
            static let tfBackground: UIColor = UIColor.fillSolidLightWhite
            static let tfStroke: UIColor = UIColor.lineOpacityNormal
        }
    }
    
    enum Cell {
        enum Size {
            static let height: CGFloat = 105
            static let profileImage: CGSize = CGSize(width: 32, height: 32)
            static let vPadding: CGFloat = 12
            static let hPadding: CGFloat = 16
        }
        enum Font {
            static let userName: UIFont = UIFont.customFont(style: .caption1SemiBold)
            static let content: UIFont = UIFont.customFont(style: .caption1Regular)
            static let date: UIFont = UIFont.customFont(style: .caption2Regular)
        }
    }
}
