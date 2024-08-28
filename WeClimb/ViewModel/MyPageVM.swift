//
//  MyPageVM.swift
//  WeClimb
//
//  Created by 강유정 on 8/27/24.
//

import RxSwift
import UIKit

class MyPageVM {

    let profileImages: Observable<[UIImage]>
    
    // 샘플 데이터 YJ
    let sampleImages: [UIImage] = [
        UIImage(named: "sampleImage1") ?? UIImage(),
        UIImage(named: "sampleImage2") ?? UIImage(),
        UIImage(named: "sampleImage3") ?? UIImage(),
        UIImage(named: "sampleImage4") ?? UIImage(),
        UIImage(named: "sampleImage5") ?? UIImage(),
    ]
    
    init() {
        profileImages = Observable.just(sampleImages)
    }
}
