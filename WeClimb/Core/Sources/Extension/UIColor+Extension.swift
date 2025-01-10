//
//  UIColor+Extension.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import UIKit

//MARK: - 메인 포인트 컬러(보라)
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let mainPurple = UIColor(hex: "#512BBB")
    static let customlightGray = UIColor(hex: "#DFE0E2")
}

extension UIColor {
    
    //MARK: - 세그먼트 커스텀 컬러
    static let fillSoildLightNormal = UIColor(hex: "#F4F5F5")
    static let fillSoildLightHeavy = UIColor(hex: "#BFCOC4")
    
    //MARK: - 알럿 커스텀 컬러
    static let fillSoildDarkNormal = UIColor(hex: "#27282B")
    static let lineOpacityHeavy = UIColor(hex: "#7F818A", alpha: 0.4)
    static let lineOpacityNormal = UIColor(hex: "#7F818A", alpha: 0.16)
    static let labelAssistive = UIColor(hex: "#BFCOC4")
    static let MaterialNormal = UIColor(hex: "#1A1A1A", alpha: 0.12)
    
    //MARK: - 필터 커스텀 컬러
    static let fillSolidDarkStrong = UIColor(hex: "#1D1E20")
}

extension UIColor {
    static let labelStrong = UIColor(hex: "#27282B")
    static let labelAlternative = UIColor(hex: "#AAABB1")
    static let lineSolidLight = UIColor(hex: "#F4F5F5")
    static let fillSolidLightWhite = UIColor(hex: "#FFF")
    static let labelWhite = UIColor(hex: "#FFF")
    static let labelNeutral = UIColor(hex: "#7F818A")
    static let fillSolidLightNormal = UIColor(hex: "#F4F5F5")
    
    
    // DS
    static let fillSolidDarkBlack = UIColor(hex: "#141415")
    static let labelNormal = UIColor(hex: "#585960")
    static let fillSolidLightLight = UIColor(hex: "#FAFAFA")
}
