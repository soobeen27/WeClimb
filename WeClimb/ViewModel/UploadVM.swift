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
    var mediaItems = BehaviorRelay(value: [PHPickerResult]())
    
    private let disposeBag = DisposeBag()
}
