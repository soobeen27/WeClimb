//
//  LevelHoldFilterCoordinator.swift
//  WeClimb
//
//  Created by 강유정 on 1/6/25.
//

import UIKit

enum LevelHoldFilterConst {
    enum Size {
        static let cellHeight: CGFloat = 45
        
        static let titleHeight: CGFloat = 48
        
        static let segmentHeight: CGFloat = 48
        
        static let LineHeight: CGFloat = 1
        
        static let filterViewHeight: CGFloat = 710
        static let filterViewCornerRadius: CGFloat = 20
    }
    
    enum Text {
        static let filterViewTiltle: String = "필터"
        static let firstSegmentTitle: String = "레벨"
        static let secondSegmentTitle: String = "홀드"
        static let applyButtonTitle : String = "적용"
    }
    
    enum Color {
        static let SegmentNormalFontColor = UIColor.labelNeutral
        
        static let lightTextColor: UIColor = .black
        static let lightLineColor: UIColor = .lineSolidLight
        static let lightBackgroundColor: UIColor = .white
        static let lightApplyButtonBackgroundColor: UIColor = .fillSolidDarkBlack
        static let lightApplyButtonTitleColor: UIColor = .white
        
        static let lightSegmentSelectedFontColor: UIColor = .labelStrong
        static let lightSegmentIndicatorColor: UIColor = .fillSolidDarkBlack
        
        static let darkTextColor: UIColor = .white
        static let darkBackgroundColor: UIColor = .fillSolidDarkStrong
        static let darkLineColor: UIColor = .lineOpacityNormal
        static let darkApplyButtonBackgroundColor: UIColor = .white
        static let darkApplyButtonTitleColor: UIColor = .labelStrong
        
        static let darkSegmentSelectedFontColor: UIColor = .white
        static let darkSegmentIndicatorColor: UIColor  = .white
    }
    
    enum padding {
        static let defaultPadding: CGFloat = 16
        
        static let titleTop: CGFloat = 15
        
        static let bottomLineTop: CGFloat = -1
    }
    
    enum CellState {
        static let initialCellCount = 0
        
        static let firstIndex = 0
        static let lastIndexOffset = 1
        
        static let tableViewSection = 0
    }
}
