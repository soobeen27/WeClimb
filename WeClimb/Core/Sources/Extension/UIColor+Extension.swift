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
    static let labelAssistive = UIColor(hex: "#BFC0C4")
    static let MaterialNormal = UIColor(hex: "#1A1A1A", alpha: 0.12)
    
    //MARK: - 필터 커스텀 컬러
    static let fillSolidDarkStrong = UIColor(hex: "#1D1E20")
    
    static let fillSolidDarkLight = UIColor(hex: "313235")
    static let BackgroundBlack = UIColor(hex: "141415")
}

extension UIColor {
    static let labelStrong = UIColor(hex: "#27282B")
    static let labelAlternative = UIColor(hex: "#AAABB1")
    static let lineSolidLight = UIColor(hex: "#F4F5F5")
    static let fillSolidLightWhite = UIColor(hex: "#FFFFFF")
    static let labelWhite = UIColor(hex: "#FFFFFF")
    static let labelNeutral = UIColor(hex: "#7F818A")
    static let fillSolidLightNormal = UIColor(hex: "#F4F5F5")
    static let fillOpacityLightStrong = UIColor(hex: "#DFE0E2", alpha: 0.2)
    static let staticWhite = UIColor(hex: "#FFFFFF")
    static let fillOpacityDarkHeavy = UIColor(hex: "#313235", alpha: 0.4)
    static let backgroundLight = UIColor(hex: "#FFFFFF")
    static let labelBlack = UIColor(hex: "#141415")
    
    
    // DS
    static let fillSolidDarkBlack = UIColor(hex: "#141415")
    static let labelNormal = UIColor(hex: "#585960")
    static let fillSolidLightLight = UIColor(hex: "#FAFAFA")
    static let statusNegative = UIColor(hex: "FB283E")
    static let primaryStrong = UIColor(hex: "8726E3")
}

extension UIColor {
    static let accentWhite = UIColor(hex: "#FFF")
    static let accentRed = UIColor(hex: "#FFE6E9")
    static let accentOrange = UIColor(hex: "#FEF4E6")
    static let accentYellow = UIColor(hex: "#FEFBE6")
    static let accentLigthGreen = UIColor(hex: "#E6FFD4")
    
    static let accentGreen = UIColor(hex: "#D9FFE6")
    static let accentMint = UIColor(hex: "#DEFAFF")
    static let accentBlue = UIColor(hex: "#E5F6FE")
    static let accentNavy = UIColor(hex: "#3385FF")
    static let accentPurple = UIColor(hex: "#6541F2")
    
    static let accentPink = UIColor(hex: "#F553DA")
    static let accentBrown = UIColor(hex: "#663A00")
    static let accentGray = UIColor(hex: "#95969D")
    static let accentBlack = UIColor(hex: "#BFC0C4")
}

extension UIColor {
    static let gradeWhite =  UIColor(hex: "#FFFFFF")
    static let gradeRed = UIColor(hex: "#FC4154")
    static let gradeOrange = UIColor(hex: "#FF9200")
    static let gradeYellow = UIColor(hex: "FAD70F")
    static let gradeLightGreen = UIColor(hex: "#6BE016")
    
    static let gradeGreen = UIColor(hex: "#00BF40")
    static let gradeMint = UIColor(hex: "#28D0ED")
    static let gradeBlue = UIColor(hex: "#00AEFF")
    static let gradeNavy = UIColor(hex: "#3385FF")
    static let gradePurple = UIColor(hex: "#6541F2")
    
    static let gradePink = UIColor(hex: "#F553DA")
    static let gradeBrown = UIColor(hex: "#663A00")
    static let gradeGray = UIColor(hex: "#95969D")
    static let gradeBlack = UIColor(hex: "#141415")
}
