//
//  PrivacyPolicyViewModel.swift
//  WeClimb
//
//  Created by 머성이 on 9/5/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol PrivacyPolicyVMType {
    func transform(input: PrivacyPolicyVM.Input) -> PrivacyPolicyVM.Output
}

class PrivacyPolicyVM: PrivacyPolicyVMType {
    
    private let snsAgreeUseCase: SNSAgreeUsecase
    private let disposeBag = DisposeBag()
    
    struct Input {
        let allTermsToggled: Observable<Void>
        let appTermsToggled: Observable<Void>
        let privacyTermsToggled: Observable<Void>
        let snsConsentToggled: Observable<Void>
    }
    
    struct Output {
        let isAllTermsAgreed: Observable<Bool>
        let isOptionalTermsAgreed: Observable<Bool>
    }

    private let isAllAgreedRelay = BehaviorRelay<Bool>(value: false)
    private let isAppTermsAgreedRelay = BehaviorRelay<Bool>(value: false)
    private let isPrivacyTermsAgreedRelay = BehaviorRelay<Bool>(value: false)
    private let isSnsConsentGivenRelay = BehaviorRelay<Bool>(value: false)
    
    init(snsAgreeUseCase: SNSAgreeUsecase) {
        self.snsAgreeUseCase = snsAgreeUseCase
        allAgreeStateCheck()
    }
    
    private func allAgreeStateCheck() {
        Observable.combineLatest(isAppTermsAgreedRelay, isPrivacyTermsAgreedRelay, isSnsConsentGivenRelay)
            .map { $0 && $1 && $2 }
            .bind(to: isAllAgreedRelay)
            .disposed(by: disposeBag)
    }
    
    private func toggle(_ relay: BehaviorRelay<Bool>) {
        relay.accept(!relay.value)
    }
    
    func transform(input: Input) -> Output {
        input.allTermsToggled
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let newState = !self.isAllAgreedRelay.value
                self.isAppTermsAgreedRelay.accept(newState)
                self.isPrivacyTermsAgreedRelay.accept(newState)
                self.isSnsConsentGivenRelay.accept(newState)
                self.updateTermsInFirebase()
            })
            .disposed(by: disposeBag)
        
        input.appTermsToggled
            .subscribe(onNext: { [weak self] in self?.toggle(self!.isAppTermsAgreedRelay) })
            .disposed(by: disposeBag)
        
        input.privacyTermsToggled
            .subscribe(onNext: { [weak self] in self?.toggle(self!.isPrivacyTermsAgreedRelay) })
            .disposed(by: disposeBag)
        
        input.snsConsentToggled
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.toggle(self.isSnsConsentGivenRelay)
                self.updateTermsInFirebase()
            })
            .disposed(by: disposeBag)
        
        return Output(
            isAllTermsAgreed: Observable.combineLatest(isAllAgreedRelay, isPrivacyTermsAgreedRelay)
                .map { $0 && $1 }
                .distinctUntilChanged(),
            isOptionalTermsAgreed: Observable.combineLatest(isAllAgreedRelay, isPrivacyTermsAgreedRelay, isSnsConsentGivenRelay)
                .map { $0 && $1 && $2 }
                .distinctUntilChanged()
        )
    }

    private func updateTermsInFirebase() {
        snsAgreeUseCase
            .excute(data: isSnsConsentGivenRelay.value, for: .snsConsent)
            .subscribe(onCompleted: {
                print("SNS 수신 동의 상태가 성공적으로 업데이트되었습니다.")
            }, onError: { error in
                print("SNS 수신 동의 상태 업데이트 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
