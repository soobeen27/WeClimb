//
//  PrivacyPolicyVM.swift
//  WeClimb
//
//  Created by 윤대성 on 1/7/25.
//

import UIKit

import RxCocoa
import RxSwift

protocol PrivacyPolicyVM {
    func transform(input: PrivacyPolicyImpl.Input) -> PrivacyPolicyImpl.Output
}

class PrivacyPolicyImpl: PrivacyPolicyVM {
    private let disposeBag = DisposeBag()
    private let usecase: SNSAgreeUsecase
    
    init(usecase: SNSAgreeUsecase) {
        self.usecase = usecase
    }
    
    struct Input {
        let toggleAllTerms: PublishRelay<Void>
        let toggleRequiredTerm: PublishRelay<Int>
        let toggleOptionalTerm: PublishRelay<Int>
        let confirmButtonTap: PublishRelay<Void>
    }
    
    struct Output {
        let allTermsAgreed: Driver<Bool>
        let requiredTermsAgreed: Driver<[Bool]>
        let optionalTermsAgreed: Driver<[Bool]>
        let isConfirmButtonEnabled: Driver<Bool>
        let updateResult: Driver<Bool>
    }
    
    private let requiredTermsRelay = BehaviorRelay<[Bool]>(value: [false, false])
    private let optionalTermsRelay = BehaviorRelay<[Bool]>(value: [false])
    
    func transform(input: Input) -> Output {
        let allTermsAgreed = Observable
            .combineLatest(requiredTermsRelay, optionalTermsRelay)
            .map { requiredTerms, optionalTerms in
                requiredTerms.allSatisfy { $0 }
            }
            .asDriver(onErrorJustReturn: false)
        
        let isConfirmButtonEnabled = requiredTermsRelay
            .map { $0.allSatisfy { $0 }}
            .asDriver(onErrorJustReturn: false)
        
        input.toggleAllTerms
            .subscribe(onNext: { [weak self] in
            let allChecked = !(self?.requiredTermsRelay.value.allSatisfy { $0 } ?? false)
                self?.requiredTermsRelay.accept(Array(repeating: allChecked, count: self?.requiredTermsRelay.value.count ?? 0))
                self?.optionalTermsRelay.accept(Array(repeating: allChecked, count: self?.optionalTermsRelay.value.count ?? 0))
            })
            .disposed(by: disposeBag)
        
        input.toggleRequiredTerm
            .withLatestFrom(requiredTermsRelay) { index, currentTerms in
            var updatedTerms = currentTerms
                updatedTerms[index] = !updatedTerms[index]
                return updatedTerms
            }
            .bind(to: requiredTermsRelay)
            .disposed(by: disposeBag)
        
        input.toggleOptionalTerm
            .withLatestFrom(optionalTermsRelay) { index, currentTerms in
            var updatedTerms = currentTerms
                updatedTerms[index] = !updatedTerms[index]
                return updatedTerms
            }
            .bind(to: optionalTermsRelay)
            .disposed(by: disposeBag)
        
        let updateResult = input.confirmButtonTap
            .withLatestFrom(optionalTermsRelay.asObservable())
            .flatMapLatest { [weak self] optionalTerms -> Observable<Bool> in
                guard let self else { return Observable.just(false) }
                
                let isSnsConsentGiven = optionalTerms.first ?? false
                return self.usecase.execute(data: isSnsConsentGiven, for: .snsConsent)
                    .andThen(Observable.just(true))
                    .catchAndReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            allTermsAgreed: allTermsAgreed,
            requiredTermsAgreed: requiredTermsRelay.asDriver(),
            optionalTermsAgreed: optionalTermsRelay.asDriver(),
            isConfirmButtonEnabled: isConfirmButtonEnabled,
            updateResult: updateResult
        )
    }
}
