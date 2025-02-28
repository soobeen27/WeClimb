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
    var confirmButtonTap: PublishRelay<Void> { get }
    //    var levelSelected: PublishRelay<String> { get }
}

protocol UserProfileSettingOutput {
    var settingItems: BehaviorRelay<[UserProfileSettingItem]> { get }
    var nicknameText: Driver<String> { get }
    var heightText: Driver<String> { get }
    var armReachText: Driver<String> { get }
    var isNicknameValid: Driver<Bool> { get }
    var updateResult: Driver<Bool> { get }
}

protocol UserProfileSettingVM {
    func transform(input: UserProfileSettingInput) -> UserProfileSettingOutput
}

class UserProfileSettingImpl: UserProfileSettingVM {
    
    private let disposeBag = DisposeBag()
    private let checkDuplicationUseCase: NicknameDuplicationCheckUseCase
    private let registerNicknameUseCase: NicknameRegisterUseCase
    private let updateUseCase: PersonalDetailUseCase
    private let userInfoFromUIDUseCase: UserInfoFromUIDUseCase
    private let currentUID: String
    
    init(checkDuplicationUseCase: NicknameDuplicationCheckUseCase, registerNicknameUseCase: NicknameRegisterUseCase, updateUseCase: PersonalDetailUseCase, userInfoFromUIDUseCase: UserInfoFromUIDUseCase, currentUID: String) {
        self.checkDuplicationUseCase = checkDuplicationUseCase
        self.registerNicknameUseCase = registerNicknameUseCase
        self.updateUseCase = updateUseCase
        self.userInfoFromUIDUseCase = userInfoFromUIDUseCase
        self.currentUID = currentUID
    }
    
    struct Input: UserProfileSettingInput {
        let nicknameInput = PublishRelay<String>()
        let heightInput = PublishRelay<String>()
        let armReachInput = PublishRelay<String>()
        let homeGymSelected = PublishRelay<String>()
        let confirmButtonTap = PublishRelay<Void>()
    }
    
    struct Output: UserProfileSettingOutput {
        let settingItems: BehaviorRelay<[UserProfileSettingItem]>
        let nicknameText: Driver<String>
        let heightText: Driver<String>
        let armReachText: Driver<String>
        let isNicknameValid: Driver<Bool>
        let updateResult: Driver<Bool>
    }
    
    func transform(input: UserProfileSettingInput) -> UserProfileSettingOutput {
        let settingItems = BehaviorRelay<[UserProfileSettingItem]>(value: [
            .homeGym(name: "선택하세요")
        ])
        
        let nicknameText = BehaviorRelay<String>(value: "")
        let heightText = BehaviorRelay<String>(value: "")
        let armReachText = BehaviorRelay<String>(value: "")
        
        userInfoFromUIDUseCase.execute(uid: currentUID)
            .subscribe(onSuccess: { user in
                nicknameText.accept(user.userName ?? "닉네임 없음")
                heightText.accept("\(user.height)")
                armReachText.accept(user.armReach != nil ? "\(user.armReach!)" : "")
            }, onFailure: { error in
                print("유저 정보를 불러오는데 실패함: \(error)")
            })
            .disposed(by: disposeBag)
        
        let sanitizedInput = input.nicknameInput
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .share(replay: 1, scope: .whileConnected)
        
        let nicknameValid = sanitizedInput
            .map { $0.count >= 2 && $0.count <= 12 }
            .share(replay: 1, scope: .whileConnected)
        
        let isNicknameAvailable = sanitizedInput
            .flatMapLatest { nickname -> Observable<Bool> in
                guard !nickname.isEmpty, nickname.count >= 2 else {
                    return Observable.just(false)
                }
                return self.checkDuplicationUseCase.execute(name: nickname)
                    .asObservable()
                    .catchAndReturn(false)
            }
            .share(replay: 1, scope: .whileConnected)
        
        let isNicknameValid = Observable.combineLatest(nicknameValid, isNicknameAvailable)
            .map { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
        
        let updateResult = input.confirmButtonTap
            .withLatestFrom(Observable.combineLatest(
                sanitizedInput,
                input.heightInput,
                input.armReachInput
            ))
            .flatMapLatest { nickname, height, armReach -> Observable<Bool> in
                let nicknameUpdate = self.registerNicknameUseCase.execute(name: nickname)
                    .flatMap { _ in Single.just(true) }
                    .asObservable()
                    .catchAndReturn(false)
                
                let heightUpdate = self.updateUseCase.execute(height: Int(height) ?? 0)
                    .andThen(Observable.just(true))
                    .catchAndReturn(false)
                
                let armReachUpdate = self.updateUseCase.execute(armReach: Int(armReach) ?? 0)
                    .andThen(Observable.just(true))
                    .catchAndReturn(false)
                
                return Observable.zip(nicknameUpdate, heightUpdate, armReachUpdate) { $0 && $1 && $2 }
            }
            .asDriver(onErrorJustReturn: false)
        
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
            nicknameText: nicknameText.asDriver(onErrorJustReturn: ""),
            heightText: heightText.asDriver(onErrorJustReturn: ""),
            armReachText: armReachText.asDriver(onErrorJustReturn: ""),
            isNicknameValid: isNicknameValid,
            updateResult: updateResult
        )
    }
}
