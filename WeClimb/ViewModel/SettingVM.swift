//
//  SettingVM.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import RxSwift

class SettingVM {
    lazy var items: Observable<[SectionModel]> = {
        return configureItems()
    }()
    
    // 섹션과 항목을 정의하고 Observable로 반환 YJ
    private func configureItems() -> Observable<[SectionModel]> {
        let notifications = [SettingItem(title: SettingNameSpace.notifications)]
        let policy = [SettingItem(title: SettingNameSpace.termsOfService), SettingItem(title: SettingNameSpace.privacyPolic)]
        let account = [SettingItem(title: SettingNameSpace.logout), SettingItem(title: SettingNameSpace.accountRemove)]
        
        let sections: [SectionModel] = [
            SectionModel(section: .notifications, items: notifications),
            SectionModel(section: .policy, items: policy),
            SectionModel(section: .account, items: account)
        ]
        
        return Observable.just(sections)
    }
}
