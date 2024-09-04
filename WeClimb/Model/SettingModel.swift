//
//  SettingModel.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import Foundation

// 섹션 타입
enum SettingSection {
    case notifications
    case policy
    case account
}

// 항목 타입
struct SettingItem {
    let title: String
}

struct SectionModel {
    let section: SettingSection
    let items: [SettingItem]
}
