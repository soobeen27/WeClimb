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
    
    // Output: 선택된 섹터에 따라 변경될 데이터
    let dummys = BehaviorRelay<[Item]>(value: [])
    
    lazy var selectedItem: Observable<Item> = self.createSelectedItemObservable()
    
    init() {
        setupBindings()
    }
    
    private func dummyDataObservable(for segmentIndex: Int) -> Observable<[Item]> {
        return Observable.just(segmentIndex)
            .map { segmentIndex in
                switch segmentIndex {
                case 0:
                    return [
                        Item(name: "1섹터"),
                        Item(name: "2섹터"),
                        Item(name: "3섹터"),
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
    }
    
    private func createSelectedItemObservable() -> Observable<Item> {
        return itemSelected
            .withLatestFrom(dummys) { indexPath, items in
                return items[indexPath.row]
            }
    }
    
    // Binding 설정을 위한 메서드
    private func setupBindings() {
        selectedSegment
            .flatMapLatest { [weak self] segmentIndex in
                return self?.dummyDataObservable(for: segmentIndex) ?? Observable.just([])
            }
            .bind(to: dummys)
            .disposed(by: disposeBag)
        
        selectedItem
            .subscribe(onNext: { [weak self] item in
                self?.updateTableViewData(for: item.name)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateTableViewData(for sectorName: String) {
        switch sectorName {
        case "1섹터":
            dummys.accept([
                Item(name: "1섹터 - 정보 1"),
                Item(name: "1섹터 - 정보 2"),
                Item(name: "1섹터 - 정보 3")
            ])
        case "2섹터":
            dummys.accept([
                Item(name: "2섹터 - 정보 1"),
                Item(name: "2섹터 - 정보 2"),
                Item(name: "2섹터 - 정보 3")
            ])
        case "3섹터":
            dummys.accept([
                Item(name: "3섹터 - 정보 1"),
                Item(name: "3섹터 - 정보 2"),
                Item(name: "3섹터 - 정보 3")
            ])
        default:
            dummys.accept([])
        }
    }
}

struct Item {
    let name: String
}
