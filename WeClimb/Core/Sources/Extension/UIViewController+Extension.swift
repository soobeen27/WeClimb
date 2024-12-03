//
//  UIViewController+Extension.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import UIKit

extension UIViewController {
    
    func presentModal(modalVC: UIViewController) {
        modalVC.modalPresentationStyle = .pageSheet
        modalVC.isModalInPresentation = false  // 모달 외부 클릭 시 모달 닫기
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]  // 미디움과 라지 크기 조절
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = nil  //모든 크기에서 배경 흐림 처리(모달 터치와 관련)
            sheet.prefersGrabberVisible = true  // 상단 그랩바
        }
        present(modalVC, animated: true, completion: nil)
    }
    private func modalTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outsideTap(_:)))
        view.superview?.addGestureRecognizer(tapGesture)
    }
    
    @objc private func outsideTap(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: self.view)
        
        //모달의 콘텐츠 영역을 제외한 빈 영역을 클릭했을 때만 모달을 닫음
        if !self.view.point(inside: touchLocation, with: nil) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 커스텀 모달
    /// iOS 16이상에서는 custom Detent를 사용하고, 15 이하는 large
    /// - Parameters:
    ///   - modalVC: 표시할 모달 뷰 컨트롤러
    ///   - heightRatio: 모달의 원하는 높이 비율 (예: 0.5 = 화면의 50%)
    ///   사용법 : let testVC = ModalTestVC()
    ///   self.presentCustomHeightModal(modalVC: testVC, heightRatio: 원하는비율)
    
    func presentCustomHeightModal(modalVC: UIViewController, heightRatio: CGFloat) {
        modalVC.modalPresentationStyle = .pageSheet
        modalVC.isModalInPresentation = false
        
        let screenHeight = UIScreen.main.bounds.height
        let height = screenHeight * heightRatio // 화면 높이에 비율을 곱해 실제 높이 계산
        
        if let sheet = modalVC.sheetPresentationController {
            if #available(iOS 16.0, *) {
                let customDetent = UISheetPresentationController.Detent.custom { _ in
                    return height
                }
                sheet.detents = [customDetent]
            } else {
                // iOS 15 이하는 .large()로 설정하고, 콘텐츠 높이를 제한하여 원하는 위치로 설정
                sheet.detents = [.large()]
                modalVC.view.frame.size.height = height
            }
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = false
        }
        present(modalVC, animated: true, completion: nil)
    }
}
