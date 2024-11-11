//
//  Hold.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/11/24.
//

import UIKit

enum Hold {
    case black
    case blue
    case other
    case gray
    case green
    case mint
    case orange
    case pink
    case purple
    case white
    case yellow
    
    var string: String {
        switch self {
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
    
    func image(color: Self) -> UIImage? {
        return UIImage(named: color.string)
    }
}
