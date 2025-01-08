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
        
        static let filterHeight: CGFloat = 710
        static let filterCornerRadius: CGFloat = 20
    }
    
    enum Text {
        static let firstSegmentTitle: String = "필터"
        static let secondSegmentTitle: String = "레벨"
        static let applyButtonTitle : String = "적용"
    }
    
    enum Color {
        static let textColor: UIColor = .black
        static let separatorLineColor: UIColor = UIColor(red: 235/255, green: 235/255, blue: 236/255, alpha: 1)
        static let backgroundColor: UIColor = .white
    }
    
    enum padding {
        static let defaultPadding: CGFloat = 16
        
        static let titleTop: CGFloat = 15
        
        static let LineTop: CGFloat = -1
    }
    
}
