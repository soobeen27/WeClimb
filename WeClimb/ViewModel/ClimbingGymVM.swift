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
    
    // Input: 셀이 눌렸을 때
    let itemSelected = PublishSubject<IndexPath>()
    let selectedSegment = BehaviorRelay<Int>(value: 0)
    
    // Output: 더미 데이터와 선택된 아이템
    lazy var dummys: Observable<[Item]> = self.dummyDataObservable()
    lazy var selectedItem: Observable<Item> = self.createSelectedItemObservable()
    
    init() {

        setupBindings()
    }
    
    private func dummyDataObservable() -> Observable<[Item]> {
        return selectedSegment
            .map { segmentIndex in
                switch segmentIndex {
                case 0:
                    return [
                        Item(name: "안농"),
                        Item(name: "과연"),
                        Item(name: "나올까?"),
                    ]
                case 1:
                    return [
                        Item(name: "와"),
                        Item(name: "이게"),
                        Item(name: "나오네"),
                    ]
                default:
                    return []
                }
            }
            .share(replay: 1, scope: .whileConnected)
    }
    
    private func createSelectedItemObservable() -> Observable<Item> {
        return itemSelected
            .withLatestFrom(dummys) { indexPath, items in
                return items[indexPath.row]
            }
    }
    // Binding 설정을 위한 메서드
    private func setupBindings() {
        selectedItem
            .subscribe(onNext: { item in
                print("Selected item: \(item.name)")
            })
            .disposed(by: disposeBag)
    }
    
}

struct Item {
    let name: String
}
