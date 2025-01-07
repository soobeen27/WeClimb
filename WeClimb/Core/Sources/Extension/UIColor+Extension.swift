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
    static let lineSolidLight = UIColor(red: 235/255, green: 235/255, blue: 236/255, alpha: 1)
    static let fillSoildLightNormal = UIColor(red: 244/255, green: 245/255, blue: 245/255, alpha: 1)
    static let fillSoildLightHeavy = UIColor(red: 191/255, green: 192/255, blue: 196/255, alpha: 1)
    
    //MARK: - 알럿 커스텀 컬러
    static let alertbackgroundGray = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.12)
    static let alertlightGray = UIColor(red: 127/255, green: 129/255, blue: 138/255, alpha: 0.16)
    static let alertTitleGray = UIColor(red: 88/255, green: 89/255, blue: 96/255, alpha: 1)
    
    //MARK: - 텍스트필드 커스텀 컬러
    static let textFieldBorderGray = UIColor(red: 127/255, green: 129/255, blue: 138/255, alpha: 0.16)
    static let fillSoildDarkNormal = UIColor(red: 39/255, green: 40/255, blue: 43/255, alpha: 1)
    static let labelStrong = UIColor(red: 39/255, green: 40/255, blue: 43/255, alpha: 1)
    static let lineOpacityStrong = UIColor(red: 127/255, green: 129/255, blue: 138/255, alpha: 0.24)
    static let lineOpacityHeavy = UIColor(red: 127/255, green: 129/255, blue: 138/255, alpha: 0.4)
    static let labelNormal = UIColor(red: 88/255, green: 89/255, blue: 96/255, alpha: 1)
    static let labelAssistive = UIColor(red: 191/255, green: 192/255, blue: 196/255, alpha: 1)
    static let MaterialNormal = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.12)
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
    static let labelAssistive = UIColor(hex: "#BFC0C4")
}
