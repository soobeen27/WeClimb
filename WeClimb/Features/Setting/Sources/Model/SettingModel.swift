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
    
    enum SectionType {
        case notifications
        case policy
        case account
    }
}
