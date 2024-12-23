//
//  UIColor+Extension.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import UIKit

//MARK: - 메인 포인트 컬러(보라)
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static let mainPurple = UIColor(hex: "#512BBB")
    
}

extension UIColor {
    static let customlightGray = UIColor(red: 235/255, green: 235/255, blue: 236/255, alpha: 1)
    static let customMediumGray = UIColor(red: 244/255, green: 245/255, blue: 245/255, alpha: 1)
    static let customGray = UIColor(red: 191/255, green: 192/255, blue: 196/255, alpha: 1)
}
