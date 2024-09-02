//
//  SearchVM.swift
//  WeClimb
//
//  Created by 강유정 on 8/27/24.
//

import UIKit

import RxSwift

class SearchViewModel {
    
    let data: Observable<[SearchModel]>
    
    // 샘플 데이터 - YJ
    let sampleData: [SearchModel] = [
        SearchModel(image: UIImage(named: "sampleImage"), title: "더클라임 클라이밍 짐앤샵 연남점", address: "서울 마포구 양화로 186 3층"),
        SearchModel(image: UIImage(named: "sampleImage"), title: "볼더프렌즈 클라이밍", address: "서울 마포구 홍익로 25 서교빌딩 지하3층")
    ]
    
    init() {
        data = Observable.just(sampleData)
    }
}
