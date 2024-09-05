//
//  PrivacyPolicyViewModel.swift
//  WeClimb
//
//  Created by 머성이 on 9/5/24.
//

import Foundation

import RxCocoa
import RxSwift

class PrivacyPolicyVM {
    // Output: View로 내보낼 데이터
    let isAllAgreed = BehaviorRelay<Bool>(value: false)
    let isTerms1Agreed = BehaviorRelay<Bool>(value: false)
    let isTerms2Agreed = BehaviorRelay<Bool>(value: false)
    let isTerms3Agreed = BehaviorRelay<Bool>(value: false)
    
    // 선택항복
    let isTerms4Agreed = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    init() {
        // 모든 개별 약관 동의 상태를 조합하여 전체 동의 여부를 계산
        Observable.combineLatest(isTerms1Agreed, isTerms2Agreed, isTerms3Agreed) { $0 && $1 && $2 }
            .bind(to: isAllAgreed)
            .disposed(by: disposeBag)
    }
    
    // Input: View에서 호출되는 액션
    func toggleTerms1() {
        isTerms1Agreed.accept(!isTerms1Agreed.value)
    }
    
    func toggleTerms2() {
        isTerms2Agreed.accept(!isTerms2Agreed.value)
    }
    
    func toggleTerms3() {
        isTerms3Agreed.accept(!isTerms3Agreed.value)
    }
    
    // 선택 항목
    func toggleTerms4() {
        isTerms4Agreed.accept(!isTerms4Agreed.value)
    }
    
    func toggleAllTerms() {
        let newState = !isAllAgreed.value
        isTerms1Agreed.accept(newState)
        isTerms2Agreed.accept(newState)
        isTerms3Agreed.accept(newState)
    }
}
