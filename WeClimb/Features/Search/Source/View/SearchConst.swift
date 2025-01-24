//
//  SearchConst.swift
//  WeClimb
//
//  Created by 강유정 on 1/23/25.
//

import UIKit

enum SearchConst {
    
    static let buttonAlphaHidden: CGFloat = 0
    static let buttonAlphaVisible: CGFloat = 1
    
    static let defaultSectionNumbers: Int = 0
    
    static let defaultSegmentIndex: Int = 0
    
    enum Color {
        static let textFieldTextColor: UIColor = .labelStrong
        static let textFieldBorderColor = UIColor.lineOpacityNormal.cgColor
        static let updatedTextFieldBorderColor = UIColor.fillSolidDarkBlack.cgColor
        static let textLabelTextColor: UIColor = .labelStrong
        static let cancelBtnTintColor: UIColor = .black
        static let backBtnTintColor: UIColor = .black
        
        static let gymImageDefaultBackground: UIColor = .lightGray
        static let gymLocationtextColor: UIColor = .labelNeutral
        static let gymNameTextColor: UIColor = .labelStrong
        static let cellCancelBtnTitleColor: UIColor = .labelNeutral
        
        static let circleCancelTintColor: UIColor = .labelAssistive
    }
    
    enum Image {
        static let searchIcon = UIImageView(image: UIImage(named: "searchIcon"))
        static let closeIcon = UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate)
        static let backIcon = UIImage(named: "chevronLeftIcon")?.withRenderingMode(.alwaysTemplate)
        
        static let emptyDefaultImage = UIImage(named: "")
        static let defaultUserImage = UIImage.avatarIconFill
        
        static let circleCancelImage = UIImage(named: "closeIcon.circle")?.withRenderingMode(.alwaysTemplate)
    }
    
    enum Font {
        static let textFieldFont: UIFont = .customFont(style: .body2Medium)
        static let textLabelFont: UIFont = .customFont(style: .label1SemiBold)
        
        static let gymLocationFont: UIFont = .customFont(style: .caption2Regular)
        static let gymNameFont: UIFont = .customFont(style: .label2SemiBold)
        static let cellCancelBtnFont: UIFont = .customFont(style: .caption1Regular)
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
        static let recentVisitTitle = "최근 방문"
        
        static let emptyText = ""
        
        enum SegmentedItems {
            static let all = "전체"
            static let gym = "암장"
            static let account = "계정"
        }
        
        static let cellCancelBtnTitle = "삭제"
        
        enum UserInfo {
            static let heightLabel = "%@cm"
            static let armReachLabel = "%@cm"
            static let heightAndArmReachLabel = "%@cm • %@cm"
        }
    }
    
    enum Shape {
        static let textFieldCornerRadius: CGFloat = 8
        static let textFieldBorderWidth: CGFloat = 1
        
        static let cellImageCornerRadius: CGFloat = 18
    }
    
    enum Search {
        
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
    }
    
    enum SearchResult {
        
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
        }
    }
    
    enum gymCell {
        
        enum Size {
            static let gymImageSize: CGFloat = 36
        }
        
        enum Spacing {
            static let gymImageleftSpacing: CGFloat = 16
            static let gymLocationleftSpacing: CGFloat = 8
            static let gymNameTopSpacing: CGFloat = 2
            static let cancelBtnRightSpacing: CGFloat = 16
        }
    }
    
    enum userCell {
        
        enum Size {
            static let userImageSize: CGFloat = 36
        }
        
        enum Spacing {
            static let userImageleftSpacing: CGFloat = 16
            static let userInfoTopSpacing: CGFloat = 2
            static let userNameleftSpacing: CGFloat = 8
            static let cancelBtnRightSpacing: CGFloat = 16
        }
    }
    
    enum textFieldRightView {
        
        enum Size {
            static let circleCancelBtnSize: CGFloat = 16
        }
        
        enum Spacing {
            static let circleCancelBtnRight: CGFloat = 12
        }
    }
    
    enum UserDefaultsKeys {
        static let recentVisitItems = "recentVisitItems"
    }
    
    static let saveRecentVisitItemMaxLimit = 10
}
