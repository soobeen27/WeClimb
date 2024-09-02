//
//  DetailEditVM.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import RxSwift
import RxCocoa

class DetailEditVM {
    // 선택된 항목을 저장하는 BehaviorRelay
    private let selectedItemRelay = BehaviorRelay<EditModel?>(value: nil)
    
    // 선택된 항목을 옵저버블로 제공
    var selectedItem: Observable<EditModel?> {
        return selectedItemRelay.asObservable()
    }
    
    // 선택된 항목을 설정
    func selectItem(_ item: EditModel) {
        selectedItemRelay.accept(item)
    }
}
