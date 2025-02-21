//
//  UserProfileSettingVM.swift
//  WeClimb
//
//  Created by 윤대성 on 2/21/25.
//

import UIKit

import RxCocoa
import RxSwift

protocol UserProfileSettingInput {
    var nicknameInput: PublishRelay<String> { get }
    var heightInput: PublishRelay<String> { get }
    var armReachInput: PublishRelay<String> { get }
    var homeGymSelected: PublishRelay<String> { get }
//    var levelSelected: PublishRelay<String> { get }
}

protocol UserProfileSettingOutput {
    var settingItems: BehaviorRelay<[UserProfileSettingItem]> { get }
    var nicknameText: BehaviorRelay<String> { get }
    var heightText: BehaviorRelay<String> { get }
    var armReachText: BehaviorRelay<String> { get }
}

protocol UserProfileSettingVM {
    func transform(input: UserProfileSettingInput) -> UserProfileSettingOutput
}

class UserProfileSettingImpl: UserProfileSettingVM {
    
    private let disposeBag = DisposeBag()
    
    struct Input: UserProfileSettingInput {
        let nicknameInput = PublishRelay<String>()
        let heightInput = PublishRelay<String>()
        let armReachInput = PublishRelay<String>()
        let homeGymSelected = PublishRelay<String>()
    }
    
    struct Output: UserProfileSettingOutput {
        let settingItems: BehaviorRelay<[UserProfileSettingItem]>
        let nicknameText: BehaviorRelay<String>
        let heightText: BehaviorRelay<String>
        let armReachText: BehaviorRelay<String>
    }
    
    func transform(input: UserProfileSettingInput) -> UserProfileSettingOutput {
        let settingItems = BehaviorRelay<[UserProfileSettingItem]>(value: [
            .homeGym(name: "선택하세요")
        ])
        
        let nicknameText = BehaviorRelay<String>(value: "")
        let heightText = BehaviorRelay<String>(value: "")
        let armReachText = BehaviorRelay<String>(value: "")
        
        input.nicknameInput
            .bind(to: nicknameText)
            .disposed(by: disposeBag)
        
        input.heightInput
            .bind(to: heightText)
            .disposed(by: disposeBag)
        
        input.armReachInput
            .bind(to: armReachText)
            .disposed(by: disposeBag)
        
        input.homeGymSelected
            .subscribe(onNext: { gymName in
                var items = settingItems.value
                if let index = items.firstIndex(where: {
                    if case .homeGym = $0 { return true }
                    return false
                }) {
                    items[index] = .homeGym(name: gymName)
                    settingItems.accept(items)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            settingItems: settingItems,
            nicknameText: nicknameText,
            heightText: heightText,
            armReachText: armReachText
        )
    }
}
