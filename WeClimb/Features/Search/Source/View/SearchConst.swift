//
//  SearchConst.swift
//  WeClimb
//
//  Created by 강유정 on 1/23/25.
//

import UIKit

enum SearchConst {
    
    enum Common {
        
        static let buttonAlphaHidden: CGFloat = 0
        static let buttonAlphaVisible: CGFloat = 1
        
        static let defaultSectionNumbers: Int = 0
        static let defaultSegmentIndex: Int = 0
        
        enum Color {
            static let textFieldText: UIColor = .labelStrong
            static let textFieldBorder = UIColor.lineOpacityNormal.cgColor
            static let updatedTextFieldBorder = UIColor.fillSolidDarkBlack.cgColor
            static let textLabelText: UIColor = .labelStrong
            
            static let textLabelTextDark: UIColor = .labelStrong
            
            static let navigationBackground = UIColor.BackgroundBlack
            static let navigationTitleText = UIColor.white
            
            static let alertConfirmButton = UIColor.statusNegative
            
            static let navigationCloseButtonTint = UIColor.white
            
            static let tableViewBackground = UIColor.white
            static let viewBackground = UIColor.white
            
            static let tableViewBackgroundDark = UIColor.BackgroundBlack
            static let viewBackgroundDark = UIColor.BackgroundBlack
            static let textFieldTextDark = UIColor.white
            static let titleLabelTextDark = UIColor.white
        }
        
        enum Image {
            static let searchIcon = UIImage(named: "searchIcon")?.resize(targetSize: CGSize(width: 20, height: 20))?
                .withTintColor(UIColor.labelAlternative, renderingMode: .alwaysOriginal)
            static let closeIcon = UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate)
            static let backIcon = UIImage(named: "chevronLeftIcon")?.withRenderingMode(.alwaysTemplate)
            
            static let emptyDefaultImage = UIImage(named: "")
            static let defaultUserImage = UIImage.avatarIconFill
        }
        
        enum Font {
            static let textFieldFont: UIFont = .customFont(style: .body2Medium)
            static let textLabelFont: UIFont = .customFont(style: .label1SemiBold)
        }
        
        enum Size {
            static let searchIconSize = CGRect(x: 0, y: 0, width: 40, height: 20)
            static let tableViewRowHeight: CGFloat = 60
            static let rightViewSize: CGFloat = 30
        }
        
        enum Spacing {
            static let searchIconleftSpacing = CGPoint(x: 12, y: 0)
        }
        
        enum Text {
            static let searchFieldPlaceholder = "검색하기"
            
            static let emptyText = ""
            
            enum Alert {
                static let closeAlertTitle = "정말 나가시겠어요?"
                static let closeAlertMessage = "입력된 내용은 저장되지 않아요."
                static let closeAlertConfirmButtonTitle = "삭제"
            }
        }
        
        enum Shape {
            static let textFieldCornerRadius: CGFloat = 8
            static let textFieldBorderWidth: CGFloat = 1
        }
    }
    
    enum Search {
                
        enum Text {
            static let navigationTitle = "편집"
            static let recentVisitTitle = "최근 방문"
        }
        
        enum Font {
            static let navigationTitle = UIFont.customFont(style: .heading2SemiBold)
        }
        
        enum Color {
            static let cancelBtnTint: UIColor = .black
            static let cancelBtnTintDark: UIColor = .white
            
            static let textFieldTextSelected: UIColor = .fillSolidDarkBlack
            static let textFieldTextSelectedDark: UIColor = .labelStrong
        }
        
        enum Size {
            static let textFieldHeight: CGFloat = 46
            static let titleLabelHeight: CGFloat = 56
            static let cancelButtonSize: CGFloat = 24
        }
        
        enum Spacing {
            static let textFieldSpacing: CGFloat = 16
            static let titleLabelSpacing: CGFloat = 16
            static let cancelBtnRightSpacing: CGFloat = 48
            
            static let updatedTextFieldRightSpacing: CGFloat = -48
            static let updatedCancelBtnRightSpacing: CGFloat = -16
            static let returnCancelBtnRightSpacing: CGFloat = 16
        }
        
        enum TabBar {
            static let defaultIndex = 0
        }
        
        enum Animation {
            static let fadeDuration: TimeInterval = 0.1
            static let visibleAlpha: CGFloat = 1
            static let hiddenAlpha: CGFloat = 0
        }
    }
    
    enum SearchResult {
        
        enum Text {
            static let navigationTitle = "암장"
            
            enum SegmentedItems {
                static let all = "전체"
                static let gym = "암장"
                static let account = "계정"
            }
        }
        
        enum Color {
            static let backBtnTint: UIColor = .black
            static let backBtnTintDark: UIColor = .labelAlternative
            
            static let LineView: UIColor = .lineSolidLight
            static let LineViewDark: UIColor = .lineOpacityNormal
        }
        
        enum Size {
            static let backBtnSize: CGFloat = 24
            static let textFieldHeight: CGFloat = 46
            static let segmentHeight: CGFloat = 48
            static let bottomLineHeight: CGFloat = 1
        }
        
        enum Spacing {
            static let backBtnleftSpacing: CGFloat = 16
            static let textFieldTopSpacing: CGFloat = 16
            static let textFieldRightSpacing: CGFloat = 16
            static let textFieldLeftSpacing: CGFloat = 8
            static let segmentRightSpacing: CGFloat = 16
            static let segmentTopSpacing: CGFloat = 16
            static let bottomLineTopSpacing: CGFloat = -1
            
            static let tableViewTopOffset: CGFloat = 16
        }
        
        enum Animation {
            static let fadeDuration: TimeInterval = 0.1
            static let visibleAlpha: CGFloat = 1
            static let hiddenAlpha: CGFloat = 0
        }
        
        enum TabBar {
              static let defaultSelectedIndex = 0
          }
        
        static let searchDebounceMilliseconds: Int = 500
    }
    
    enum Cell {
        
        enum Text {
            static let cellCancelBtnTitle = "삭제"
            
            enum UserInfo {
                static let heightLabel = "%@cm"
                static let armReachLabel = "%@cm"
                static let heightAndArmReachLabel = "%@cm • %@cm"
            }
        }
        
        enum Size {
            static let gymImageSize: CGFloat = 36
            
            static let userImageSize: CGFloat = 36
        }
        
        enum Spacing {
            static let gymImageleftSpacing: CGFloat = 16
            static let gymLocationleftSpacing: CGFloat = 8
            static let gymNameTopSpacing: CGFloat = 2
            
            static let cancelBtnRightSpacing: CGFloat = 16
            
            static let userImageleftSpacing: CGFloat = 16
            static let userInfoTopSpacing: CGFloat = 2
            static let userNameleftSpacing: CGFloat = 8
        }
        
        enum Color {
            static let cellCancelBtnTitleColor: UIColor = .labelNeutral
            
            static let background: UIColor = .white
            static let backgroundDark: UIColor = .BackgroundBlack
            
            static let gymNameText: UIColor = .labelStrong
            static let gymLocationText: UIColor = .labelNeutral
            
            static let gymNameTextDark: UIColor = .labelWhite
            static let gymLocationTextDark: UIColor = .labelWhite
            static let gymImageDefaultBackground: UIColor = .lightGray
            
            static let userNameText: UIColor = .labelStrong
            static let userInfoText: UIColor = .labelNeutral
            
            static let userNameTextDark: UIColor = .labelWhite
            static let userInfoTextDark: UIColor = .labelWhite
        }
        
        enum Font {
            static let gymLocationFont: UIFont = .customFont(style: .caption2Regular)
            static let gymNameFont: UIFont = .customFont(style: .label2SemiBold)
            static let cellCancelBtnFont: UIFont = .customFont(style: .caption1Regular)
        }
        
        enum Shape {
            static let cellImageCornerRadius: CGFloat = 18
        }
    }
    
    enum textFieldRightView {
        
        enum Size {
            static let circleCancelBtnSize: CGFloat = 16
        }
        
        enum Spacing {
            static let circleCancelBtnRight: CGFloat = 12
        }
        
        enum Image {
            static let circleCancelImage = UIImage(named: "closeIcon.circle")?.withRenderingMode(.alwaysTemplate)
        }
        
        enum Color {
            static let circleCancelTint: UIColor = .labelAssistive
            static let circleCancelTintDark: UIColor = .labelAlternative
        }
    }
    
    enum UserDefaultsKeys {
        static let recentVisitItems = "recentVisitItems"
    }
    
    static let saveRecentVisitItemMaxLimit = 10
}
