//
//  LevelHoldFilterTableCellConst.swift
//  WeClimb
//
//  Created by 강유정 on 1/9/25.
//

import UIKit

enum LevelHoldFilterCellConst {
    static let cellTitleFont: UIFont = UIFont.customFont(style: .label2Regular)
    
    enum Color {
        static let rightSeparatorLineColor: UIColor = .lineOpacityNormal
        
        static let lightCellBackgroundColor: UIColor = .white
        static let lightIsCheckedCellTitleColor: UIColor = .black
        static let lightNormalCellTitleColor: UIColor = .labelNeutral

        static let darkCellBackgroundColor: UIColor = .fillSolidDarkStrong
        static let darkIsCheckedCellTitleColor: UIColor = .white
        static let darkNormalCellTitleColor: UIColor = .labelAssistive
    }
    
    enum Size {
        static let rightSeparatorLineWidth: CGFloat = 43
        static let rightSeparatorLineHeight: CGFloat = 1
    }
    
    enum padding {
        static let defaultPadding: CGFloat = 16
        
        static let titleLeading: CGFloat = 8
    }
    
    enum Text {
        static let checkSuffix = "Check"
    }
    
    enum Icon {
        static let firstCellHarderIcon = UIImage(named: "harderIcon")
        static let lastCellEasierIcon = UIImage(named: "easierIcon")
    }
}
