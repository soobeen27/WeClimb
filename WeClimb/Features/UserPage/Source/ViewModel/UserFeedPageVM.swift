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
    private let fetchFeedUseCase: FetchUserFeedInfoUseCase
    private let userId: String
    
    let userFeedList = BehaviorRelay<[UserFeedTableCellVMImpl]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    init(fetchFeedUseCase: FetchUserFeedInfoUseCase, userId: String) {
        self.fetchFeedUseCase = fetchFeedUseCase
        self.userId = userId
    }
    
    struct Input: UserFeedPageVMInput {
        var fetchUserFeedTrigger = PublishRelay<Void>() // 최초 데이터 로드
        var loadMoreTrigger = PublishRelay<Void>() // 무한 스크롤
    }
    
    struct Output: UserFeedPageVMOutput {
        let userFeedList: BehaviorRelay<[UserFeedTableCellVMImpl]>
        let isLoading: BehaviorRelay<Bool>
    }
    
    func transform(input: UserFeedPageVMInput) -> UserFeedPageVMOutput {
        input.fetchUserFeedTrigger
            .flatMapLatest { [weak self] _ -> Observable<[PostWithHold]> in
                guard let self = self else { return .just([]) }
                self.isLoading.accept(true)
                return self.fetchFeedUseCase.execute(userId: self.userId)
                    .asObservable()
            }
            .subscribe(onNext: { [weak self] postsWithHold in
                guard let self = self else { return }
                self.isLoading.accept(false)
                
                self.userFeedList.accept(postsWithHold.map { UserFeedTableCellVMImpl(postWithHold: $0) })
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                print("Error fetching feeds: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        return Output(
            userFeedList: userFeedList,
            isLoading: isLoading
        )
    }
}
