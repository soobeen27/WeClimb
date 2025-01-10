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
        let errorMessage: Driver<String>
        let updateResult: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let nicknameRelay = BehaviorRelay<String>(value: "")
        let errorMessageRelay = BehaviorRelay<String?>(value: nil)
        let updateResultRelay = PublishRelay<Bool>()

        input.nicknameInput
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.count <= OnboardingConst.CreateNickname.Size.maxCharacterCount }
            .bind(to: nicknameRelay)
            .disposed(by: disposeBag)
        
        let isNicknameValid = nicknameRelay
            .map { [weak self] nickname in
                guard let self = self else { return false }
                return self.normalizeNickname(nickname).count >= OnboardingConst.CreateNickname.Size.minCharacterCount
            }
            .asDriver(onErrorJustReturn: false)
        
        let characterCount: Driver<Int> = nicknameRelay
            .map { $0.count }
            .asDriver(onErrorJustReturn: OnboardingConst.CreateNickname.Status.boolValue)
        
        input.confirmButtonTap
            .withLatestFrom(nicknameRelay)
            .flatMapLatest { nickname in
                self.checkDuplicationUseCase.execute(name: nickname)
                    .flatMap { isDuplicate -> Single<Bool> in
                        if isDuplicate {
                            errorMessageRelay.accept(OnboardingConst.CreateNickname.Text.errorMessageDuplicate)
                            return Single.just(false)
                        }
                        return self.registerNicknameUseCase.execute(name: nickname)
                            .andThen(Single.just(true))
                    }
                    .catch { error in
                        errorMessageRelay.accept("\(OnboardingConst.CreateNickname.Text.errorMessage) \(error.localizedDescription)")

                        return Single.just(false)
                    }
            }
            .subscribe(onNext: { success in
                updateResultRelay.accept(success)
            })
            .disposed(by: disposeBag)
        
        let errorMessage = errorMessageRelay
            .map { $0 ?? "" }
            .asDriver(onErrorJustReturn: "")
        
        let updateResult = updateResultRelay
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            isNicknameValid: isNicknameValid,
            characterCount: characterCount,
            errorMessage: errorMessage,
            updateResult: updateResult
        )
    }
    
    private func normalizeNickname(_ nickname: String) -> String {
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)
        let regex = OnboardingConst.CreateNickname.Text.regex
        return trimmed.range(of: regex, options: .regularExpression) != nil ? trimmed : ""
    }
}
