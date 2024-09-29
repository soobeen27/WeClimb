//
//  EditPageVM.swift
//  WeClimb
//
//  Created by 강유정 on 8/30/24.
//

import RxSwift

class EditPageVM {
    
    let items: Observable<[EditModel]>
    
    // 샘플 데이터 YJ
    private let sampleData: [EditModel] = [
        EditModel(title: "이름(닉네임)", info: "위클"),
        EditModel(title: "키 | 팔길이", info: "170cm | 180cm")
    ]
    
    init() {
        items = Observable.just(sampleData)
    }
}


