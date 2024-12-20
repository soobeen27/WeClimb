//
//  Untitled.swift
//  WeClimb
//
//  Created by 강유정 on 12/20/24.
//

import UIKit

enum RectangleButtonSize {
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
    
    var iconSize: CGFloat {
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
    
    var interval: CGFloat {
        return 6
    }
}
