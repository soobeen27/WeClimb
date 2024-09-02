//
//  DetailEditVM.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import RxSwift
import RxCocoa

class DetailEditVM {
    private let selectedItemRelay = BehaviorRelay<EditModel>(value: EditModel(title: "", info: ""))
    
    var selectedItem: Observable<EditModel> {
        return selectedItemRelay.asObservable()
    }
    
    //MARK: - 새로운 값을 받고 업데이트하는 메서드 YJ
    func selectItem(_ item: EditModel) {
        selectedItemRelay.accept(item)
    }
}
