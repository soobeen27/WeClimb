//
//  UploadMenuConst.swift
//  WeClimb
//
//  Created by 강유정 on 2/20/25.
//

import UIKit

enum UploadMenuConst {
    
    enum UploadMenuVC {
        
        enum Text {
            static let title = "어떤 게시물인가요?"
            static let description = "게시물의 유형을 선택해주세요."
            
            static let climbingBtnTitle = "완등"
        }
        
        enum Color {
            static let titleText = UIColor.labelStrong
            static let descriptionText = UIColor.labelNeutral
            
            static let climbingBtnTitle = UIColor.labelNeutral
            static let climbingBtnBackground = UIColor.clear
            
            static let buttonTopBorder = UIColor.lineSolidLight
            
            static let viewBackground = UIColor.white
            static let viewShadow = UIColor.black
        }
        
        enum Font {
            static let title = UIFont.customFont(style: .label1SemiBold)
            static let description = UIFont.customFont(style: .body2Regular)
            
            static let climbingBtnTitle = UIFont.customFont(style: .label2Medium)
        }
        
        enum Size {
            static let viewCornerRadius: CGFloat = 16
            static let viewShadowOpacity: Float = 0.2
            static let viewShadowOffset = CGSize(width: 0, height: 0)
            static let viewShadowRadius: CGFloat = 10
            
            static let buttonTopBorderHeight: CGFloat = 1
            static let buttonTopBorderInsetX: CGFloat = -16
            static let buttonTopBorderInsetY: CGFloat = 0
            static let buttonTopBorderWidth: CGFloat = 250
        }
        
        enum Layout {
            static let titleTopOffset: CGFloat = 16
            static let titleSideInset: CGFloat = 16
            static let titleHeight: CGFloat = 24
            
            static let descriptionTopOffset: CGFloat = 4
            static let descriptionSideInset: CGFloat = 16
            static let descriptionHeight: CGFloat = 22
            
            static let climbingBtnTopOffset: CGFloat = 16
            static let climbingBtnSideInset: CGFloat = 16
            static let climbingBtnHeight: CGFloat = 54
        }
    }
}
