//
//  DefaultAlertVCNS.swift
//  WeClimb
//
//  Created by 강유정 on 12/26/24.
//

import Foundation

enum DefaultAlertConst {
  
    enum Text {
        static let cancel = "취소"
        static let custom = "확인"
        static let title = "취소"
        static let description = "확인"
    }
    
    enum Size {
        static let alertViewWidth: CGFloat = 280
        static let titleHeight: CGFloat = 24
        static let descriptionHeight: CGFloat = 22
        static let customButtonWidth: CGFloat = 118.5
        static let customButtonHeight: CGFloat = 39
        static let confirmationButtonWidth: CGFloat = 248
        static let confirmationButtonHeight: CGFloat = 39
    }
    
    enum Spacing {
        static let alertViewHorizontalInset: CGFloat = 50
        static let titleHorizontalInset: CGFloat = 16
        static let titleTopInset: CGFloat = 16
        static let descriptionHorizontalInset: CGFloat = 16
        static let descriptionTopOffset: CGFloat = 4
        static let buttonTopOffset: CGFloat = 16
        static let buttonHorizontalInset: CGFloat = 16
        static let buttons: CGFloat = 11
    }

    enum CornerRadius {
        static let alertView: CGFloat = 15
        static let buttons: CGFloat = 8
    }
    
    static let numberOfLinesDescription: Int = 10
    static let borderWidthButton: CGFloat = 10
    
    enum Animation {
        static let fadeInDuration: TimeInterval = 0.3
        static let fadeOutDuration: TimeInterval = 0.3
        static let zoomInScale: CGFloat = 1.2
        static let zoomOutScale: CGFloat = 0.8
        static let alphaVisible: CGFloat = 1.0
        static let alphaHidden: CGFloat = 0.0
    }
}
