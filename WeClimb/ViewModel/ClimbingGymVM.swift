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
    
    let itemSelected = PublishSubject<IndexPath>()
    let selectedSegment = BehaviorRelay<Int>(value: 0)
    
    let dummys = BehaviorRelay<[Item]>(value: [])
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        selectedSegment
            .flatMapLatest { [weak self] segmentIndex in
                return self?.dummyDataObservable(for: segmentIndex) ?? Observable.just([])
            }
            .bind(to: dummys)
            .disposed(by: disposeBag)
        
        itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let selectedItem = self.dummys.value[indexPath.row]
                
                // 안전하게 이미지 로드
                let detailItems = [
                    DetailItem(image: UIImage(named: "testImage") ?? UIImage(), description: "\(selectedItem.name) detail 1"),
                    DetailItem(image: UIImage(named: "testImage") ?? UIImage(), description: "\(selectedItem.name) detail 2")
                ]
                
                // 로그 출력
                print("Item selected at \(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }
    
    private func dummyDataObservable(for segmentIndex: Int) -> Observable<[Item]> {
        // 섹션 데이터
        return Observable.just(segmentIndex)
            .map { segmentIndex in
                switch segmentIndex {
                case 0:
                    return [
                        Item(name: "1섹터"),
                        Item(name: "2섹터"),
                        Item(name: "3섹터"),
                        Item(name: "4섹터"),
                        Item(name: "5섹터"),
                        Item(name: "6섹터"),
                    ]
                default:
                    return []
                }
            }
    }
}

struct Item {
    let name: String
    let progress: Float
    let itemCount: Int
    
    init(name: String, progress: Float = 0.0, itemCount: Int = 0) {
        self.name = name
        self.progress = progress
        self.itemCount = itemCount
    }
}

