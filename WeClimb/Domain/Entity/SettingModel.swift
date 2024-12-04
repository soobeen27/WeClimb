//
//  SettingModel.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import Foundation

struct SettingItem {
    let section: SectionType
    let titles: [String]
    
    enum SectionType: CustomStringConvertible {
        case notifications
        case policy
        case account
        
        var description: String {
            switch self {
            case .notifications:
                return "알림"
            case .policy:
                return "정책"
            case .account:
                return "계정 관리"
            }
        }
    }
}
