//
//  ClimbingFilterVM.swift
//  WeClimb
//
//  Created by 머성이 on 11/11/24.
//

import UIKit

import RxCocoa
import RxSwift

class ClimbingFilterVM {
    // MARK: - Output
    struct Output {
        let filteredPosts: Driver<[Post]>
    }

    let output: Output
    
    private let filterConditionsRelay = BehaviorRelay<FilterConditions>(
        value: FilterConditions(holdColor: nil, heightRange: (0, 200), armReachRange: (0, 200))
    )
    private let filteredPostsSubject = BehaviorSubject<[Post]>(value: [])
    private let gymName: String
    private let grade: String
    private let disposeBag = DisposeBag()

    init(gymName: String, grade: String) {
        self.gymName = gymName
        self.grade = grade

        self.output = Output(
            filteredPosts: filteredPostsSubject.asDriver(onErrorJustReturn: [])
        )
    }

    func updateFilterCondition(holdColor: String? = nil, heightRange: (Int, Int)? = nil, armReachRange: (Int, Int)? = nil) {
        // 현재 필터 조건 가져오기
        var currentConditions = filterConditionsRelay.value

        // 필요한 조건만 업데이트
        if let holdColor = holdColor {
            currentConditions.holdColor = holdColor
        }
        if let heightRange = heightRange {
            currentConditions.heightRange = heightRange
        }
        if let armReachRange = armReachRange {
            currentConditions.armReachRange = armReachRange
        }

        // Relay에 새로운 조건 전달
        filterConditionsRelay.accept(currentConditions)
    }
}
