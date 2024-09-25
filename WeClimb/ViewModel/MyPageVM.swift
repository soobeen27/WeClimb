//
//  MyPageVM.swift
//  WeClimb
//
//  Created by 강유정 on 8/27/24.
//

import UIKit

import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseAuth

class MyPageVM {

    let profileImages: Observable<[UIImage]>
    let db = Firestore.firestore()
    
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
  
        // Firestore에서 유저 정보 확인

}
