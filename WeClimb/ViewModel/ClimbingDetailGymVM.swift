//
//  ClimbingGymDetailVM.swift
//  WeClimb
//
//  Created by 머성이 on 9/1/24.
//

import UIKit

import RxCocoa
import RxSwift

class ClimbingDetailGymVM {
    
    private let disposeBag = DisposeBag()
    
    // 상세 화면에 표시할 데이터를 담는 프로퍼티
    let detailData = BehaviorRelay<[DetailItem]>(value: [])
    
    init(detailItems: [DetailItem]) {
        // 초기 데이터 설정
        self.detailData.accept(detailItems)
    }
}
