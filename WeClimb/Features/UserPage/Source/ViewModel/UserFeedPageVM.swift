//
//  UserFeedPageVM.swift
//  WeClimb
//
//  Created by 윤대성 on 2/5/25.
//

import Foundation

import RxCocoa
import RxSwift

protocol UserFeedPageVMInput {
    var fetchUserFeedTrigger: PublishRelay<Void> { get }
    var loadMoreTrigger: PublishRelay<Void> { get }
}

protocol UserFeedPageVMOutput {
    var userFeedList: BehaviorRelay<[UserFeedTableCellVMImpl]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
}

protocol UserFeedPageVM {
    func transform(input: UserFeedPageVMInput) -> UserFeedPageVMOutput
}

class UserFeedPageVMImpl: UserFeedPageVM {
    private let disposeBag = DisposeBag()
    
    
    struct Input: UserFeedPageVMInput {
        var fetchUserFeedTrigger = PublishRelay<Void>() // 최초 데이터 로드
        var loadMoreTrigger = PublishRelay<Void>() // 무한 스크롤
    }
    
    struct Output: UserFeedPageVMOutput {
        let userFeedList: BehaviorRelay<[UserFeedTableCellVMImpl]>
        let isLoading: BehaviorRelay<Bool>
    }
    
    func transform(input: UserFeedPageVMInput) -> UserFeedPageVMOutput {
        <#code#>
    }
}
