//
//  ButtonsConst.swift
//  WeClimb
//
//  Created by 강유정 on 1/2/25.
//

import UIKit

enum WeClimbButtonConst {
    
    enum Color {
        static let defaultBackgroundColor: UIColor = .black
        static let defaultTintColor: UIColor = .white
        static let defaultTitleColor: UIColor = .white
    }
    
    enum DefaultRectangle {
        static let cornerRadius: CGFloat = 10
        
        enum Size {
            static let width: CGFloat = 343
            static let height: CGFloat = 48
        }
    }
    
    enum IconRectangleSize {
        case large
        case medium
        case small
        
        var fontType: UIFont {
            switch self {
            case .large:
                return .customFont(style: .label1SemiBold)
            case .medium:
                return .customFont(style: .label2Medium)
            case .small:
                return .customFont(style: .caption1Medium)
            }
        }
        
        var icon: CGFloat {
            switch self {
            case .large:
                return 20
            case .medium:
                return 18
            case .small:
                return 16
            }
        }
        
        var width: CGFloat {
            switch self {
            case .large:
                return 136
            case .medium:
                return 113
            case .small:
                return 93
            }
        }
        
        var height: CGFloat {
            switch self {
            case .large:
                return 48
            case .medium:
                return 39
            case .small:
                return 30
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .large:
                return 28
            case .medium:
                return 20
            case .small:
                return 14
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .large:
                return 10
            case .medium:
                return 8
            case .small:
                return 6
            }
        }
        
        var spacing: CGFloat {
            return 6
        }
        
        enum Layout {
            static let defaultWidth: CGFloat = 0
            static let iconCount: CGFloat = 2
            static let spacingCount: CGFloat = 2
            static let paddingCount: CGFloat = 2
        }
    }
    
    enum RightIconRound {
        static let cornerRadius: CGFloat = 15
        
        enum Size {
            static let imageSize: CGFloat = 14
            static let width: CGFloat = 65
            static let height: CGFloat = 30
        }
        
        enum Spacing {
            static let rightPadding: CGFloat = 14
            static let leftPadding: CGFloat = 10
            static let spacing: CGFloat = 6
        }
    }
}
