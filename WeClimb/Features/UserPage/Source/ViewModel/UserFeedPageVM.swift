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
    var fetchUserInfoTrigger: PublishRelay<Void> { get }
}

protocol UserFeedPageVMOutput {
    var userFeedList: BehaviorRelay<[UserFeedTableCellVMImpl]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var userInfo: BehaviorRelay<User?> { get }
}

protocol UserFeedPageVM {
    func transform(input: UserFeedPageVMInput) -> UserFeedPageVMOutput
}

class UserFeedPageVMImpl: UserFeedPageVM {
    private let disposeBag = DisposeBag()
    private let fetchFeedUseCase: FetchUserFeedInfoUseCase
    private let myUserInfoUseCase: MyUserInfoUseCase
    private let userUID: String
    
    let userFeedList = BehaviorRelay<[UserFeedTableCellVMImpl]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let userInfo = BehaviorRelay<User?>(value: nil)
    
    init(fetchFeedUseCase: FetchUserFeedInfoUseCase, myUserInfoUseCase: MyUserInfoUseCase, userUID: String) {
        self.fetchFeedUseCase = fetchFeedUseCase
        self.myUserInfoUseCase = myUserInfoUseCase
        self.userUID = userUID
    }
    
    struct Input: UserFeedPageVMInput {
        var fetchUserFeedTrigger = PublishRelay<Void>() // 최초 데이터 로드
        var loadMoreTrigger = PublishRelay<Void>() // 무한 스크롤
        var fetchUserInfoTrigger = PublishRelay<Void>()
    }
    
    struct Output: UserFeedPageVMOutput {
        let userFeedList: BehaviorRelay<[UserFeedTableCellVMImpl]>
        let isLoading: BehaviorRelay<Bool>
        var userInfo: BehaviorRelay<User?>
    }
    
    func transform(input: UserFeedPageVMInput) -> UserFeedPageVMOutput {
        
        input.fetchUserInfoTrigger
            .flatMapLatest { [weak self] _ -> Single<User?> in
                guard let self = self else { return .just(nil) }
                return self.myUserInfoUseCase.execute()
            }
            .subscribe(onNext: { [weak self] user in
                self?.userInfo.accept(user)
            }, onError: { error in
                print("사용자 정보 가져오기 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        input.fetchUserFeedTrigger
                .flatMapLatest { [weak self] _ -> Observable<[PostWithHold]> in
                    guard let self = self else { return .just([]) }
                    self.isLoading.accept(true)
                    return self.fetchFeedUseCase.execute(userUID: self.userUID)
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
            isLoading: isLoading,
            userInfo: userInfo
        )
    }
}
