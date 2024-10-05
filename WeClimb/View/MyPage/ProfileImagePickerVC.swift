//
//  ProfileImagePickerVC.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import PhotosUI

import RxSwift
import RxCocoa

class ProfileImagePickerVC: NSObject {
    private let imageSubject = PublishSubject<UIImage?>()
    
    var imageObservable: Observable<UIImage?> {
        return imageSubject.asObservable()
    }
    
    // 이미지 피커를 화면에 표시하는 메서드
    func presentImagePicker(from viewController: UIViewController) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1    // 한 번에 하나의 이미지만 선택 가능
        configuration.filter = .images      // 필터로 이미지만 선택하도록
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true, completion: nil)
    }
}

extension ProfileImagePickerVC: PHPickerViewControllerDelegate {
    // 사용자가 사진이나 비디오를 선택한 후 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        // 선택된 결과 처리
        guard let result = results.first else {
            imageSubject.onNext(nil)
            return
        }
        
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else { return }
                if let selectedImage = image as? UIImage {
                    self.imageSubject.onNext(selectedImage)  // 선택된 이미지 방출
                } else {
                    self.imageSubject.onNext(nil)
                }
            }
        } else {
            imageSubject.onNext(nil)
        }
    }
}
