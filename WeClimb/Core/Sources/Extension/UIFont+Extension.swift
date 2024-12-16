//
//  Untitled.swift
//  WeClimb
//
//  Created by 강유정 on 12/16/24.
//

import UIKit


extension UIFont {
    /// 폰트 extension
    /// - Parameters:
    ///   - fontSize: 원하는 폰트 사이즈
    ///   - weight: 원하는 폰트 두께
    /// - Returns: 해당 사이즈와 두께에 맞는 폰트 반환
    static func pretendard(size fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let familyName = "Pretendard"

        var weightString: String
        switch weight {
        case .black:
            weightString = "Black"
        case .heavy:
            weightString = "ExtraBold"
        case .bold:
            weightString = "Blod"
        case .medium:
            weightString = "Medium"
        case .regular:
            weightString = "Regular"
        case .semibold:
            weightString = "SemiBold"
        case .light:
            weightString = "Light"
        case .ultraLight:
            weightString = "ExtraLight"
        case .thin:
            weightString = "Thin"
        default:
            weightString = "Regular"
        }

        return UIFont(name: "\(familyName)-\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
    }
}
