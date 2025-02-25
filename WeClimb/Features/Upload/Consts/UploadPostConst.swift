//
//  UploadPostConst.swift
//  WeClimb
//
//  Created by 강유정 on 2/20/25.
//

import UIKit

enum UploadPostConst {
    
    enum UploadPostVC {
        
        enum Text {
            static let submitButtonTitle = "등록"
            
            static let navigationTitle = "편집"
            static let closeAlertTitle = "정말 나가시겠어요?"
            static let closeAlertMessage = "입력된 내용은 저장되지 않아요."
            static let closeAlertButtonTitle = "삭제"
            
            static let textViewPlaceholder = " 내용을 입력해주세요."
            static let textViewCharCountFormat = "%d/1000"
        }
        
        enum Color {
            static let topSeparator = UIColor.lineOpacityNormal
            static let bottomSeparator = UIColor.lineOpacityNormal
            static let collectionViewBackground = UIColor.fillSolidDarkBlack
            static let gymButtonForeground = UIColor.white
            static let gymButtonBackground = UIColor.fillOpacityDarkHeavy
            static let submitButtonText = UIColor.labelStrong
            static let submitButtonBackground = UIColor.white
            static let safeAreaBackground = UIColor.fillSolidDarkStrong
            static let loadingOverlay = UIColor.black.withAlphaComponent(0.5)
            static let loadingIndicator = UIColor.white
            
            static let navigationBarBackground = UIColor.fillSolidDarkBlack
            static let navigationTitleText = UIColor.white
            static let navigationButtonTint = UIColor.white
            static let alertButtonText = UIColor.statusNegative
            
            static let background = UIColor.fillSolidDarkBlack
            
            static let textViewDefault = UIColor.labelNormal
            static let textViewEditingBorder = UIColor.white
            static let textViewText = UIColor.white
        }
        
        enum Font {
            static let gymButtonTitle = UIFont.customFont(style: .caption1Medium)
            static let submitButtonTitle = UIFont.customFont(style: .label1SemiBold)
            
            static let navigationTitle = UIFont.customFont(style: .heading2SemiBold)
            
            static let textViewEditing = UIFont.customFont(style: .body2SemiBold)
        }
        
        enum Image {
            static let navigationBackIcon = UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate)
        }
        
        enum Size {
            static let gymButtonImage = CGSize(width: 12, height: 12)
            static let gymButtonCornerRadius: CGFloat = 8
            static let gymButtonImagePadding: CGFloat = 4
            
            static let collectionViewCornerRadius: CGFloat = 11
            
            static let collectionViewItemWidth: CGFloat = 125
            static let collectionViewItemHeight: CGFloat = 222
            static let collectionViewItemSpacing: CGFloat = 12
            
            static let collectionViewItemInset: CGFloat = 12
            static let collectionViewSectionInsetTop: CGFloat = 0
            static let collectionViewSectionInsetBottom: CGFloat = 0
        }
        
        enum Layout {
            static let submitButtonZPosition: CGFloat = 1
            static let gymButtonZPosition: CGFloat = 1
            
            static let separatorHeight: CGFloat = 1
            static let gymButtonTopOffset: CGFloat = 16
            static let gymButtonLeadingOffset: CGFloat = 16
            static let gymButtonHeight: CGFloat = 26
            static let collectionViewTopOffset: CGFloat = 16
            static let collectionViewHeight: CGFloat = 222
            static let bottomSeparatorTopOffset: CGFloat = -16
            static let submitButtonBottomOffset: CGFloat = -16
            static let submitButtonSideInset: CGFloat = 16
            static let submitButtonHeight: CGFloat = 48
            
            static let bottomSeparatorHeight: CGFloat = 1
            static let topSeparatorHeight: CGFloat = 1
        }
        
        enum Keyboard {
            static let defaultOffset: CGFloat = 0
            static let extraPadding: CGFloat = 80
            static let defaultAnimationDuration: Double = 0.3
            
            static let TextLimit = 1000
        }
    }
    
    enum UploadTextView {
        
        enum Text {
            static let title = "문구"
            static let placeholder = " 내용을 입력해주세요."
            static let helpMessage = "도움말 메세지"
            static let charCountFormat = "0/1000"
        }
        
        enum Color {
            static let titleText = UIColor.white
            static let textViewText = UIColor.labelNormal
            static let textViewBackground = UIColor.fillSolidDarkBlack
            static let textViewBorder = UIColor.lineOpacityNormal
            static let helpMessageText = UIColor.labelNeutral
            static let charCountText = UIColor.labelNeutral
            
            static let viewBackground = UIColor.fillSolidDarkStrong
        }
        
        enum Font {
            static let title = UIFont.customFont(style: .label1Medium)
            static let textView = UIFont.customFont(style: .body2Medium)
            static let helpMessage = UIFont.customFont(style: .caption1Regular)
            static let charCount = UIFont.customFont(style: .caption1Regular)
        }
        
        enum Size {
            static let textViewCornerRadius: CGFloat = 8
            static let textViewBorderWidth: CGFloat = 1
            
            static let viewIntrinsicContent = CGSize(width: UIView.noIntrinsicMetric, height: 212)
            static let viewCornerRadius: CGFloat = 20
        }
        
        enum Layout {
            static let titleLeadingOffset: CGFloat = 16
            static let titleTopOffset: CGFloat = 16
            
            static let textViewTopOffset: CGFloat = 8
            static let textViewSideInset: CGFloat = 16
            
            static let helpMessageLeadingOffset: CGFloat = 16
            static let helpMessageTopOffset: CGFloat = 8
            
            static let charCountTrailingOffset: CGFloat = -16
            static let charCountTopOffset: CGFloat = 8
            
            static let textViewCornerRadius: CGFloat = 8
            static let textViewBorderWidth: CGFloat = 1
            static let textViewHeight: CGFloat = 128
        }
    }
    
    enum UploadPostVM {
        
        enum MediaFileExtensions {
            static let imageJPG = "jpg"
            static let imagePNG = "png"
            static let videoMP4 = "mp4"
        }
        
        enum Compression {
            static let imageQuality: CGFloat = 0.3
            static let videoBitrate: Int = 2
            static let maxVideoDuration: Double = 120
        }
    }
}
