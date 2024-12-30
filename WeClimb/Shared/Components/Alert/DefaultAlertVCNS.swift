//
//  DefaultAlertVCNS.swift
//  WeClimb
//
//  Created by 강유정 on 12/26/24.
//

import Foundation

enum DefaultAlertVCNS {
  
    enum Text {
        static let cancelButton = "취소"
        static let customButton = "확인"
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
    
    enum NumberOfLines {
        static let description: Int = 2
    }
    
    enum borderWidth {
          static let button: CGFloat = 1
      }
    
    enum Animation {
        static let fadeInDuration: TimeInterval = 0.3
        static let fadeOutDuration: TimeInterval = 0.3
        static let zoomInScale: CGFloat = 1.2
        static let zoomOutScale: CGFloat = 0.8
        static let alphaVisible: CGFloat = 1.0
        static let alphaHidden: CGFloat = 0.0
    }
}
