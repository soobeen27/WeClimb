//
//  Untitled.swift
//  WeClimb
//
//  Created by 강유정 on 12/16/24.
//

import UIKit

enum CustomFontStyle {
    case title1Bold
    case title1Medium
    case title1Regular
    
    case title2SemiBold
    case title2Medium
    case title2Regular
    
    case heading1SemiBold
    case heading1Medium
    case heading1Regular
    
    case heading2SemiBold
    case heading2Medium
    case heading2Regular
    
    case body1SemiBold
    case body1Medium
    case body1Regular
    
    case body2SemiBold
    case body2Medium
    case body2Regular
    
    case label1SemiBold
    case label1Medium
    case label1Regular
    
    case label2SemiBold
    case label2Medium
    case label2Regular
    
    case caption1SemiBold
    case caption1Medium
    case caption1Regular
    
    case caption2SemiBold
    case caption2Medium
    case caption2Regular
}

extension UIFont {
    
    static func customFont(style: CustomFontStyle) -> UIFont {
        let familyName = "Pretendard"
        var weightString: String
        var fontSize: CGFloat
        
        switch style {
        case .title1Bold:
            weightString = "Bold"
            fontSize = 28
        case .title1Medium:
            weightString = "Medium"
            fontSize = 28
        case .title1Regular:
            weightString = "Regular"
            fontSize = 28
            
        case .title2SemiBold:
            weightString = "SemiBold"
            fontSize = 24
        case .title2Medium:
            weightString = "Medium"
            fontSize = 24
        case .title2Regular:
            weightString = "Regular"
            fontSize = 24
            
        case .heading1SemiBold:
            weightString = "SemiBold"
            fontSize = 20
        case .heading1Medium:
            weightString = "Medium"
            fontSize = 20
        case .heading1Regular:
            weightString = "Regular"
            fontSize = 20
            
        case .heading2SemiBold:
            weightString = "SemiBold"
            fontSize = 18
        case .heading2Medium:
            weightString = "Medium"
            fontSize = 18
        case .heading2Regular:
            weightString = "Regular"
            fontSize = 18
            
        case .body1SemiBold:
            weightString = "SemiBold"
            fontSize = 16
        case .body1Medium:
            weightString = "Medium"
            fontSize = 16
        case .body1Regular:
            weightString = "Regular"
            fontSize = 16
            
        case .body2SemiBold:
            weightString = "SemiBold"
            fontSize = 14
        case .body2Medium:
            weightString = "Medium"
            fontSize = 14
        case .body2Regular:
            weightString = "Regular"
            fontSize = 14
            
        case .label1SemiBold:
            weightString = "SemiBold"
            fontSize = 16
        case .label1Medium:
            weightString = "Medium"
            fontSize = 16
        case .label1Regular:
            weightString = "Regular"
            fontSize = 16
            
        case .label2SemiBold:
            weightString = "SemiBold"
            fontSize = 14
        case .label2Medium:
            weightString = "Medium"
            fontSize = 14
        case .label2Regular:
            weightString = "Regular"
            fontSize = 14
            
        case .caption1SemiBold:
            weightString = "SemiBold"
            fontSize = 12
        case .caption1Medium:
            weightString = "Medium"
            fontSize = 12
        case .caption1Regular:
            weightString = "Regular"
            fontSize = 12
            
        case .caption2SemiBold:
            weightString = "SemiBold"
            fontSize = 10
        case .caption2Medium:
            weightString = "Medium"
            fontSize = 10
        case .caption2Regular:
            weightString = "Regular"
            fontSize = 10
        }
        
        return UIFont(name: "\(familyName)-\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize)
    }
}
