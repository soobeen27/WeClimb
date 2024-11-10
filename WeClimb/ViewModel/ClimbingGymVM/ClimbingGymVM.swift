//
//  ClimbingGymVM.swift
//  WeClimb
//
//  Created by 머성이 on 8/26/24.
//

import UIKit

import RxCocoa
import RxSwift

class ClimbingGymVM {
    struct Input {
        let segmentSelected: PublishRelay<Int>
        let difficultySelected: PublishRelay<IndexPath>
    }
    
    struct Output {
        let gymData: Driver<Gym?>
        let isDataLoaded: Driver<Bool>
        let items: Driver<[(color: UIColor, grade: String)]>
        let grades: Driver<[String]>
        let selectedSegment: Driver<Int>
    }

    let input: Input
    let output: Output
    
    private let disposeBag = DisposeBag()
    private var requestedGymNames = Set<String>()
    
    private let isDataLoadedRelay = BehaviorRelay<Bool>(value: false)
    private let gymDataRelay = BehaviorRelay<Gym?>(value: nil)
    private let gradesRelay = BehaviorRelay<[String]>(value: [])
    private let itemsRelay = BehaviorRelay<[(color: UIColor, grade: String)]>(value: [])
    private let selectedSegmentRelay = BehaviorRelay<Int>(value: 0)  // 초기값 0
    
    init() {
        let segmentSelected = PublishRelay<Int>()
        let difficultySelected = PublishRelay<IndexPath>()
        
        input = Input(segmentSelected: segmentSelected, difficultySelected: difficultySelected)
        
        output = Output(
            gymData: gymDataRelay.asDriver(),
            isDataLoaded: isDataLoadedRelay.asDriver(),
            items: itemsRelay.asDriver(),
            grades: gradesRelay.asDriver(),
            selectedSegment: selectedSegmentRelay.asDriver()
        )
        
        segmentSelected
            .bind(to: selectedSegmentRelay)
            .disposed(by: disposeBag)
        
        segmentSelected
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                if index == 0 {
                    self.updateItems()
                } else {
                    self.itemsRelay.accept([])
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setGymInfo(gymName: String) {
        guard !requestedGymNames.contains(gymName) else {
            print("이미 암장 정보를 불러오는 중")
            return
        }
        
        requestedGymNames.insert(gymName)
        isDataLoadedRelay.accept(false)
        
        FirebaseManager.shared.gymInfo(from: gymName) { [weak self] gym in
            guard let self = self, let gym = gym else {
                self?.isDataLoadedRelay.accept(true)
                return
            }
            
            DispatchQueue.main.async {
                self.gymDataRelay.accept(gym)
                
                let sectorNames = gym.grade.components(separatedBy: ", ")
                self.gradesRelay.accept(sectorNames)
                
                self.updateItems()
                
                self.isDataLoadedRelay.accept(true)
            }
        }
    }
    
    private func updateItems() {
        let updatedItems = gradesRelay.value.map { gradeString -> (color: UIColor, grade: String) in
            let color = gradeString.colorInfo.color
            return (color: color, grade: gradeString)
        }
        
        itemsRelay.accept(updatedItems)
    }
}
