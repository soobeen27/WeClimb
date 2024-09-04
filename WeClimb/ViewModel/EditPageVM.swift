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
        EditModel(title: "이름", info: "홍길동"),
        EditModel(title: "이메일", info: "aaa@naver.com"),
        EditModel(title: "전화번호", info: "000-0000-0000"),
        EditModel(title: "생년월일", info: "0000.00.00")
    ]
    
    init() {
        items = Observable.just(sampleData)
    }
}
