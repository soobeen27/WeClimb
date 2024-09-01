//
//  EditPageVM.swift
//  WeClimb
//
//  Created by 강유정 on 8/30/24.
//

import RxSwift

class EditPageViewModel {
    
    let items: Observable<[(title: String, info: String)]>
    
    // 샘플 데이터 YJ
    private let sampleData: [(String, String)] = [
        ("이름", "홍길동"),
        ("이메일", "aaa@naver.com"),
        ("전화번호", "000-0000-0000"),
        ("생년월일", "0000.00.00")
    ]
    
    init() {
        items = Observable.just(sampleData)
    }
}
