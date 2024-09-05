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
    
    let navigateToGymPage = PublishSubject<Void>()
    let showDropDownMenu = PublishSubject<Void>()
    
    func optionSelected(optionText: String) {
        if optionText == UploadNameSpace.selectGym {
            navigateToGymPage.onNext(())
        } else if optionText == UploadNameSpace.selectSector {
            showDropDownMenu.onNext(())
        }
    }
}
