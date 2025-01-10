//
//  Hold.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/11/24.
//

import UIKit

/// CaseIterable -> 열거형의 각각 모든 case들을 한데 묶어서 컬렉션인 배열로 만들어주는 프로토콜 채택.
enum Hold : String, CaseIterable {
    case white = "white"
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    case mint = "mint"
    case blue = "blue"
    case purple = "purple"
    case pink = "pink"
    case gray = "gray"
    case black = "black"
    case other = "other"
    
    var string: String {
        switch self {
        case .red:
            return "holdRed"
        case .black:
            return "holdBlack"
        case .blue:
            return "holdBlue"
        case .other:
            return "holdOther"
        case .gray:
            return "holdGray"
        case .green:
            return "holdGreen"
        case .mint:
            return "holdMint"
        case .orange:
            return "holdOrange"
        case .pink:
            return "holdPink"
        case .purple:
            return "holdPurple"
        case .white:
            return "holdWhite"
        case .yellow:
            return "holdYellow"
        }
    }
    
    var koreanHold: String {
        switch self {
        case .red:
            return "빨강"
        case .black:
            return "검정"
        case .blue:
            return "파랑"
        case .other:
            return "기타"
        case .gray:
            return "회색"
        case .green:
            return "초록"
        case .mint:
            return "민트"
        case .orange:
            return "주황"
        case .pink:
            return "핑크"
        case .purple:
            return "보라"
        case .white:
            return "하양"
        case .yellow:
            return "노랑"
        }
    }
    
    var imageName: String {
        switch self {
        case .red: return "colorRed"
        case .black: return "colorBlack"
        case .blue: return "colorBlue"
        case .other: return "colorOther"
        case .gray: return "colorGray"
        case .green: return "colorGreen"
        case .mint: return "colorMint"
        case .orange: return "colorOrange"
        case .pink: return "colorPink"
        case .purple: return "colorPurple"
        case .white: return "colorWhite"
        case .yellow: return "colorYellow"
        }
    }

    func image() -> UIImage? {
        return UIImage(named: self.imageName)
    }
    
//    func image() -> UIImage? {
//        return UIImage(named: self.string)
//    }
}
