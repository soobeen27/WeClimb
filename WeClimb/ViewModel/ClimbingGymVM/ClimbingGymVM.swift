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
    
    private let disposeBag = DisposeBag()
    private var requestedGymNames = Set<String>()
    
    let isDataLoaded = BehaviorRelay<Bool>(value: false)
    let gymData = BehaviorRelay<Gym?>(value: nil)
    
    let grades = BehaviorRelay<[String]>(value: [])
    let items = BehaviorRelay<[(color: UIColor, grade: String)]>(value: [])
    
    let selectedSegment = BehaviorRelay<Int>(value: 0)
    let itemSelected = PublishSubject<IndexPath>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        selectedSegment
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                if index == 0 {
                    self.updateItems()
                } else {
                    self.items.accept([])
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
        isDataLoaded.accept(false)
        
        FirebaseManager.shared.gymInfo(from: gymName) { [weak self] gym in
            guard let self = self, let gym = gym else {
                self?.isDataLoaded.accept(true)
                return
            }
            
            DispatchQueue.main.async {
                self.gymData.accept(gym)
                
                let sectorNames = gym.grade.components(separatedBy: ", ")
                self.grades.accept(sectorNames)
                
                self.updateItems()
                
                self.isDataLoaded.accept(true)
            }
        }
    }
    
    private func updateItems() {
        let updatedItems = grades.value.map { gradeString -> (color: UIColor, grade: String) in
            let color = gradeString.colorInfo.color
            // let problemCount = 0  // 암장 문제 개수 (추후 데이터로 업데이트 예정)
            // let feedCount = 0  // 메인피드에서 받아올 문제 개수 (추후 데이터로 업데이트 예정)
            return (color: color, grade: gradeString) // 기본값으로 문제 및 피드 개수 설정
        }
        
        items.accept(updatedItems)
    }

}
