//
//  UploadVM.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import PhotosUI
import UIKit

import RxCocoa
import RxSwift

class UploadVM {
    // 피커뷰
    var mediaItems = BehaviorRelay(value: [PHPickerResult]())
    
    func optionSelected(optionText: String) {
        print("선택된 옵션: \(optionText)")
    }
}
