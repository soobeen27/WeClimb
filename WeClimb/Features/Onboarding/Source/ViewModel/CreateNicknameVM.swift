//
//  CreateNicknameVM.swift
//  WeClimb
//
//  Created by 윤대성 on 1/8/25.
//

import UIKit

import RxCocoa
import RxSwift

protocol CreateNicknameVM {
    func transform(input: CreateNicknameImpl.Input) -> CreateNicknameImpl.Output
}

class CreateNicknameImpl: CreateNicknameVM {
    private let disposeBag = DisposeBag()
    private let checkDuplicationUseCase: NicknameDuplicationCheckUseCase
    private let registerNicknameUseCase: NicknameRegisterUseCase
    
    init(checkDuplicationUseCase: NicknameDuplicationCheckUseCase,
         registerNicknameUseCase: NicknameRegisterUseCase) {
        self.checkDuplicationUseCase = checkDuplicationUseCase
        self.registerNicknameUseCase = registerNicknameUseCase
    }
    
    struct Input {
        let nicknameInput: Observable<String>
        let confirmButtonTap: Observable<Void>
    }
    
    struct Output {
        let isNicknameValid: Driver<Bool>
        let characterCount: Driver<Int>
        let updateResult: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let sanitizedInput = input.nicknameInput
            .map { self.normalizeNickname($0) }
            .share(replay: 1, scope: .whileConnected)
        
        let nicknameValid = sanitizedInput
            .map { nickname -> Bool in
                return nickname.count >= OnboardingConst.CreateNickname.Size.minCharacterCount && nickname.count <= OnboardingConst.CreateNickname.Size.maxCharacterCount
            }
            .share(replay: 1, scope: .whileConnected)
        
        let characterCount = sanitizedInput
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        let isNicknameAvailable = Observable.combineLatest(
            sanitizedInput,
            input.confirmButtonTap.startWith(Void())
        )
            .map { nickname, _ in nickname }
            .flatMapLatest { nickname -> Observable<Bool> in
                if nickname.isEmpty || nickname.count < OnboardingConst.CreateNickname.Size.minCharacterCount || nickname.count > OnboardingConst.CreateNickname.Size.maxCharacterCount {
                    return Observable.just(true)
                }
                
                return self.checkDuplicationUseCase.execute(name: nickname)
                    .asObservable()
                    .catch { error in
                        print("Error checking duplication: \(error)")
                        return Observable.just(false)
                    }
            }
            .startWith(true)
            .share(replay: 1, scope: .whileConnected)

        let isNicknameAvailableCombined = Observable.combineLatest(
            nicknameValid,
            isNicknameAvailable
        ) { isValid, isAvailable in
            return isValid && isAvailable
        }
            .share(replay: 1, scope: .whileConnected)
        
        Observable.combineLatest(nicknameValid, isNicknameAvailable)
            .subscribe(onNext: { isValid, isAvailable in
            })
            .disposed(by: disposeBag)
        
        let updateResult = input.confirmButtonTap
            .withLatestFrom(Observable.combineLatest(sanitizedInput, isNicknameAvailableCombined))
            .flatMapLatest { nickname, isAvailableCombined -> Observable<Bool> in
                guard isAvailableCombined else {
                    return .just(false)
                }
                return self.registerNicknameUseCase.execute(name: nickname)
                    .flatMap { _ in Single.just(true) }
                    .asObservable()
                    .catchAndReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            isNicknameValid: nicknameValid.asDriver(onErrorJustReturn: false),
            characterCount: characterCount,
            updateResult: updateResult
        )
    }
    
    private func normalizeNickname(_ nickname: String) -> String {
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)
        let regex = OnboardingConst.CreateNickname.Text.regex
        return trimmed.range(of: regex, options: .regularExpression) != nil ? trimmed : ""
    }
}
