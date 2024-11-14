//
//  ClimbingFilterVM.swift
//  WeClimb
//
//  Created by 머성이 on 11/11/24.
//

import RxCocoa
import RxSwift

class ClimbingFilterVM {
    
    // MARK: - Input/Output 정의
    struct Input {
        let holdSelected: AnyObserver<Void>
        let armReachSelected: AnyObserver<Void>
    }
    
    struct Output {
        let selectedTab: Driver<SelectedTab>
    }
    
    // MARK: - Private Properties
    private let holdSelectedSubject = PublishSubject<Void>()
    private let armReachSelectedSubject = PublishSubject<Void>()
    private let selectedTabRelay = BehaviorRelay<SelectedTab>(value: .hold)
    
    let input: Input
    let output: Output
    private let disposeBag = DisposeBag()
    
    // MARK: - 초기화 및 바인딩 설정
    init() {
        input = Input(
            holdSelected: holdSelectedSubject.asObserver(),
            armReachSelected: armReachSelectedSubject.asObserver()
        )
        
        output = Output(
            selectedTab: selectedTabRelay.asDriver()
        )
        
        // Input 바인딩: 사용자가 탭을 선택할 때 상태를 업데이트
        holdSelectedSubject
            .map { SelectedTab.hold }
            .bind(to: selectedTabRelay)
            .disposed(by: disposeBag)
        
        armReachSelectedSubject
            .map { SelectedTab.armReach }
            .bind(to: selectedTabRelay)
            .disposed(by: disposeBag)
    }
    
    enum SelectedTab {
        case hold
        case armReach
    }
}

