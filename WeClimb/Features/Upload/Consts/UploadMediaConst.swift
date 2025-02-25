//
//  UploadMediaConst.swift
//  WeClimb
//
//  Created by 강유정 on 2/19/25.
//

import UIKit

enum UploadMediaConst {
    
    enum cell {
        enum MediaFileExtensions {
            static let imageJPG = "jpg"
            static let imagePNG = "png"
            static let videoMP4 = "mp4"
        }
        
        enum Image {
            static let placeholder = UIImage(named: "placeholder")
        }
    }
    
    enum UploadMediaVC {
        enum Color {
            static let gymBtnBaseForeground = UIColor.white
            static let gymBtnbaseBackground = UIColor.fillOpacityDarkHeavy
            
            static let separatorLine = UIColor.lineOpacityNormal
            
            static let mediaView = UIColor.fillSolidDarkBlack
            
            static let safeAreaBackgroundView = UIColor.fillSolidDarkStrong
            
            static let navigationForeground = UIColor.white
            
            static let alertCustomBtnTitle = UIColor.statusNegative
        }
        
        enum Size {
            static let gymButtonImagePadding: CGFloat = 4
            static let gymButtonCornerRadius: CGFloat = 8
            static let gymButtonZPosition: CGFloat = 1
            
            static let PHPickerBtnCornerRadius: CGFloat = 10
        }
        
        enum Font {
            static let gymButton: UIFont = .customFont(style: .caption1Medium)
            
            static let navigation: UIFont = .customFont(style: .heading2SemiBold)
        }
        
        enum Image {
            static let gymBtn = UIImage.locationIconFill.resize(targetSize: CGSize(width: 12, height: 12))?
                .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            
            static let PHPickerBtn = UIImage.imageAddIcon.resize(targetSize: CGSize(width: 20, height: 20))?
                .withTintColor(UIColor.labelNormal, renderingMode: .alwaysOriginal)
            
            static let navigationCloseIcon = UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate)
        }
        
        enum Text {
            static let navigationTitle = "선택"
            
            static let closeAlertTitle = "정말 나가시겠어요?"
            static let closeAlertMessage = "입력된 내용은 저장되지 않아요."
            
            static let AlertDelete = "삭제"
            static let AlertConfirm = "확인"
            
            static let emptyMediaTitle = "미디어가 없습니다."
            static let emptyMediaMessage = "업로드할 사진 또는 영상을 선택해주세요."
            
            static let missingSelectionTitle = "선택되지 않은 항목이 있습니다."
            static let missingSelectionMessage = "레벨과 홀드를 모두 선택해주세요."
            
            static let noMediaForFilterTitle = "미디어 없습니다."
            static let noMediaForFilterMessage = "미디어를 추가한 후 필터를 선택해주세요."
        }
        
        enum PHPicker {
            static let selectionLimit = 10
        }
        
        enum Layout {
            static let separatorLineHeight: CGFloat = 1
            static let gymButtonHeight: CGFloat = 26
            static let gymButtonTop: CGFloat = 16
            static let gymButtonLeading: CGFloat = 16
            static let PHPickerButtonSize: CGFloat = 100
        }
    }
    
    enum FeedView {
        enum Color {
            static let countLabelText = UIColor.white
            static let countLabelBackground = UIColor.fillOpacityDarkHeavy
            
            static let CollectionViewBackground = UIColor.clear
        }
        
        enum Font {
            static let countLabel = UIFont.customFont(style: .caption1Medium)
        }
        
        enum Size {
            static let countLabelCornerRadius: CGFloat = 13
            
            static let CollectionViewItemWidth: CGFloat = 256
            static let CollectionViewItemSpacing: CGFloat = 12
            static func CollectionViewInset(viewWidth: CGFloat) -> CGFloat {
                return (viewWidth - Size.CollectionViewItemWidth) / 2
            }
        }
        
        enum Text {
            static let countLabelFormat = "%d / %d"
        }
        
        enum Layout {
            static let CountLabelWidth: CGFloat = 41
            static let CountLabelHeight: CGFloat = 26
            static let CountLabelTopOffset: CGFloat = 16
            static let CountLabelTrailingOffset: CGFloat = -16
            
            static let CollectionViewTopOffset: CGFloat = 16
        }
        
        enum Scroll {
            static let speedLimit: CGFloat = 0.4
            
            static let firstMediaIndex: Int = 0
            static let firstMediaDisplayIndex: Int = 1
            static let nextPageOffset: Int = 1
            
        }
    }
    
    enum UploadOptionView {
        
        enum Color {
            static let labelText = UIColor.white
            static let btnText = UIColor.labelAssistive
            static let btnTint = UIColor.labelAssistive
            
            static let separatorLine = UIColor.lineOpacityNormal
            
            static let backButtonText = UIColor.labelAssistive
            static let backButtonBackground = UIColor.fillSolidDarkLight
            static let nextButtonBackground = UIColor.white
            static let nextButtonText = UIColor.black
            
            static let viewBackground = UIColor.fillSolidDarkStrong
        }
        
        enum Font {
            static let levelLabel = UIFont.customFont(style: .label1Medium)
            static let holdLabel = UIFont.customFont(style: .label1Medium)
            static let button = UIFont.customFont(style: .caption1Medium)
            static let selectedButton = UIFont.customFont(style: .label2Regular)
            
            static let selectedOption = UIFont.customFont(style: .label2Regular)
        }
        
        enum Image {
            static let levelOption = UIImage.colorWhite.resize(targetSize: CGSize(width: 16, height: 16))?
                .withRenderingMode(.alwaysTemplate)
            static let holdOption = UIImage.colorWhite.resize(targetSize: CGSize(width: 16, height: 16))?
                .withRenderingMode(.alwaysTemplate)
            static let chevronRight = UIImage.chevronRightIcon.resize(targetSize: CGSize(width: 20, height: 20))?
                .withTintColor(UIColor.labelAssistive, renderingMode: .alwaysOriginal)
            static let arrowLeft = UIImage(named: "arrowLeftIcon")?.withRenderingMode(.alwaysTemplate)
            static let arrowRight = UIImage(named: "arrowRightIcon")?.withRenderingMode(.alwaysTemplate)
            
            static let backButtonIcon = UIImage(named: "arrowLeftIcon")?.withRenderingMode(.alwaysTemplate)
            static let nextButtonIcon = UIImage(named: "arrowRightIcon")?.withRenderingMode(.alwaysTemplate)
            
            static let defaultGradeColor = UIImage.closeIconCircle
            static let defaultHoldColor = UIImage.closeIconCircle
        }
        
        enum Text {
            static let levelLabel = "레벨"
            static let holdLabel = "홀드"
            static let selectPlaceholder = "선택해주세요"
            static let backButtonTitle = "이전"
            static let nextButtonTitle = "다음"
            
            static let defaultSelection = "선택해주세요"
            
            static let holdSuffixToRemove = "hold"
        }
        
        enum Layout {
            static let btnImagePadding: CGFloat = 4
            static let btnContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            static let levelOptionImageSpacing: CGFloat = -8
            static let holdOptionImageSpacing: CGFloat = -8
            
            static let defultOffset: CGFloat = 16
            
            static let optionImageSpacing: CGFloat = -8
            static let buttonTopOffset: CGFloat = 10
            static let optionLabelHeight: CGFloat = 56
            static let separatorHeight: CGFloat = 1
            static let buttonHeight: CGFloat = 30
            static let buttonBottomOffset: CGFloat = -10
        }
        
        enum Size {
            static let viewIntrinsicContent = CGSize(width: UIView.noIntrinsicMetric, height: 57)
            static let viewCornerRadius: CGFloat = 20
        }
    }
    
    enum UploadMenu {
        
        enum Layout {
            static let viewWidth: CGFloat = 250
            static let viewHeight: CGFloat = 136
            
            static let viewBottomOffset: CGFloat = -16
        }
        
        enum Animation {
            static let fadeDuration: TimeInterval = 0.3
            static let tabBarFadeInDuration: TimeInterval = 0.1
            
            static let fadeInAlpha: CGFloat = 1
        }
        
        enum TabBar {
            static let defaultIndex: Int = 0
            static let uploadTabIndex: Int = 2
            
            static let hiddenAlpha: CGFloat = 0
        }
    }
    
    enum UploadVM {
        enum Text {
            static let videoLengthExceededTitle = "영상 길이 초과"
            static let videoLengthExceededMessage = "2분 이내의 영상을 업로드해주세요."
        }
        
        enum Video {
            static let maxDuration: Double = 120.0
            static let fileExtension = "mp4"
        }
        
        enum Image {
            static let fileExtension = "jpg"
        }
        
        enum Dispatch {
            static let syncQueueLabel = "com.upload.syncQueue"
        }
    }
}
