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
    
    // 데이터 로딩 상태
    let isDataLoaded = BehaviorRelay<Bool>(value: false)
    
    let gymData = BehaviorRelay<Gym?>(value: nil)
    let grades = BehaviorRelay<[String]>(value: [])
    let items = BehaviorRelay<[String]>(value: [])
    let selectedSegment = BehaviorRelay<Int>(value: 0)
    let itemSelected = PublishSubject<IndexPath>()
    
//    var onItemSelected: (([DetailItem]) -> Void)?
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        
        Observable.combineLatest(selectedSegment, grades)
                .map { selectedIndex, grades in
                    if selectedIndex == 0 {
                        return selectedIndex == 0 ? grades : []
                    } else {
                        return []
                    }
                }
                .bind(to: items)
                .disposed(by: disposeBag)
        
//        itemSelected
//            .withLatestFrom(items) { ($0, $1) }
//            .subscribe(onNext: { [weak self] (indexPath, items) in
//                guard let self else { return }
//                
//                let selectedItem = items[indexPath.row]
//                
////                // 선택된 Item으로부터 DetailItem 생성 및 전달
////                let detailItems = self.createDetailItems(from: selectedItem)
//                
////                self.onItemSelected?(detailItems)
//            })
//            .disposed(by: disposeBag)
        
        grades
            .subscribe(onNext: { [weak self] grades in
                guard let self else { return }
                
                let selectedIndex = self.selectedSegment.value
                self.items.accept(selectedIndex == 0 ? grades : [])
            })
            .disposed(by: disposeBag)
    }
    
    func setGymInfo(gymName: String) {
        // 이미 요청된 Gym이면 중복 요청 방지
        guard !requestedGymNames.contains(gymName) else {
            print("이미 암장 정보를 불러오는 중")
            return
        }

        requestedGymNames.insert(gymName)
        isDataLoaded.accept(false)
        
        // Firebase에서 암장 정보를 가져옴
        FirebaseManager.shared.gymInfo(from: gymName) { [weak self] gym in
            guard let self = self, let gym = gym else {
                self?.isDataLoaded.accept(true)
                return
            }
            
            DispatchQueue.main.async {
                self.gymData.accept(gym)
                
                let sectorNames = gym.grade.components(separatedBy: ", ")
                self.grades.accept(sectorNames)
                
                self.isDataLoaded.accept(true)
            }
        }
    }
    
//    // 선택된 Item에서 DetailItem 생성
//    private func createDetailItems(from item: Item) -> [DetailItem] {
//        return [
//            DetailItem(image: UIImage(named: "testImage"), description: "\(item.name) 파랑보라", videoCount: item.itemCount),
//            DetailItem(image: UIImage(named: "testImage"), description: "\(item.name) 파랑보라", videoCount: item.itemCount),
//        ]
//    }
}
