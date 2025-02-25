//
//  CustomSegmentConstants.swift
//  WeClimb
//
//  Created by 윤대성 on 12/30/24.
//

import UIKit

enum CustomSegmentConst {
    enum Color {
        static let indicatorColor: UIColor = UIColor.fillSolidDarkBlack
        static let normalFontColor: UIColor = UIColor.labelNeutral
        static let selectedFontColor: UIColor = UIColor.labelStrong
        
        static let indicatorColorDark: UIColor = UIColor.white
        static let normalFontColorDark: UIColor = UIColor.white
        static let selectedFontColorDark: UIColor = UIColor.white
    }
    
    enum Font {
        static let normalFont: UIFont = UIFont.customFont(style: CustomFontStyle.body1Regular)
        static let selectedFont: UIFont = UIFont.customFont(style: CustomFontStyle.body1SemiBold)
    }
    
    enum Size {
        static let firstSegmentItem = 0
        static let segmentControlHeight: CGFloat = 44
        static let indicatorHeight: CGFloat = 3
    }
    
    enum Spacing {
        static let indicatorBottomOffset: CGFloat = 2
    }
    
    enum Helper {
        /// 각 세그먼트의 제목 너비를 계산하는 메서드
        static func titleWidth(for title: String?, font: UIFont) -> CGFloat {
            guard let title = title else { return 0 }
            return title.size(withAttributes: [.font: font]).width
        }
        
        /// 세그먼트의 가로 중심 좌표를 계산하는 메서드
        static func centerX(for segmentWidth: CGFloat, at index: Int) -> CGFloat {
            return segmentWidth * CGFloat(index) + segmentWidth / 2
        }
    }
}
