//
//  SearchVM.swift
//  WeClimb
//
//  Created by 강유정 on 8/27/24.
//

import RxSwift
import UIKit

class SearchViewModel {
    
    let data: Observable<[(image: UIImage?, title: String, address: String)]>
    
    // 샘플 데이터 - YJ
    let sampleData: [(image: UIImage?, title: String, address: String)] = [
        (UIImage(named: "sampleImage"), "더클라임 클라이밍 짐앤샵 연남점", "서울 마포구 양화로 186 3층"),
        (UIImage(named: "sampleImage"), "볼더프렌즈 클라이밍", "서울 마포구 홍익로 25 서교빌딩 지하3층")
    ]
    
    init() {
        data = Observable.just(sampleData)
    }
}
