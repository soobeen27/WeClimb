//
//  PersonalDetailsVM.swift
//  WeClimb
//
//  Created by 김솔비 on 9/24/24.
//

import Foundation

import RxCocoa
import RxSwift

class PersonalDetailsVM {
    
//    let disposeBag = DisposeBag()
//    
//    let heightInput = PublishSubject<String>()
//    let armReachInput = PublishSubject<String>()
//    
//    private var currentHeight: String?
//    private var currentArmReach: String?
//
//    init() {
//        heightInput.subscribe(onNext: { [weak self] height in
//            self?.currentHeight = height
//        }).disposed(by: disposeBag)
//
//        armReachInput.subscribe(onNext: { [weak self] armReach in
//            self?.currentArmReach = armReach
//        }).disposed(by: disposeBag)
//    }
    
    let disposeBag = DisposeBag()
        
        // BehaviorRelay로 변경하고 초기값을 설정합니다.
        let heightInput = BehaviorRelay<Int>(value: 0)
        let armReachInput = BehaviorRelay<Int>(value: 0)
        
        private var currentHeight: Int?
        private var currentArmReach: Int?

        init() {
            heightInput.subscribe(onNext: { [weak self] height in
                self?.currentHeight = height
            }).disposed(by: disposeBag)

            armReachInput.subscribe(onNext: { [weak self] armReach in
                self?.currentArmReach = armReach
            }).disposed(by: disposeBag)
        }
}
