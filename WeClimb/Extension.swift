//
//  Extension.swift
//  WeClimb
//
//  Created by 김솔비 on 8/26/24.
//

import UIKit

//MARK: - 메인 포인트 컬러(보라)
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static let mainPurple = UIColor(hex: "#512BBB")
}


//MARK: - 좋아요 버튼 애니메이션
extension UIButton {
    
    //버튼의 활성화 상태를 나타내는 변수
    private struct AssociatedKeys {
        static var isActivated = "isActivated"
    }
    
    var isActivated: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isActivated) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isActivated, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateImage()
        }
    }
    
    //활성화 상태
    private var activatedImage: UIImage? {
        return UIImage(systemName: "heart.fill")?
            .withTintColor(UIColor(hex: "#DA407A"))
            .withRenderingMode(.alwaysOriginal)
    }
    
    //비활성화 상태
    private var normalImage: UIImage? {
        return UIImage(systemName: "heart")?
            .withTintColor(UIColor(hex: "#FFFFFF"))  //"#CDCDCD"
            .withRenderingMode(.alwaysOriginal)
    }
    
    //버튼의 이미지를 현재 상태에 따라 업데이트
    private func updateImage() {
        let image = isActivated ? activatedImage : normalImage
        self.setImage(image, for: .normal)
    }
    
    func configureHeartButton() {
        self.updateImage() // 초기 이미지 설정
        self.addTarget(self, action: #selector(onHeartButtonClicked), for: .touchUpInside)
    }
    
    //버튼클릭 시 호출
    @objc 
    private func onHeartButtonClicked() {
        self.isActivated.toggle() // 활성화 상태를 변경
        animateHeartButton() // 애니메이션 적용
    }
    
    //버튼클릭 시 애니메이션을 적용
    private func animateHeartButton() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            // 클릭되었을 때 축소되는 애니메이션
            self.transform = self.transform.scaledBy(x: 0.5, y: 0.5)
        }, completion: { _ in
            // 원래 크기로 되돌아가는 애니메이션
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}


//MARK: - 높이 조절 가능한 모달
extension UIViewController {
    
    func presentModal(modalVC: UIViewController) {
        modalVC.modalPresentationStyle = .pageSheet
        modalVC.isModalInPresentation = false  // 모달 외부 클릭 시 모달 닫기
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]  // 미디움과 라지 크기 조절
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true  // 상단 그랩바
        }
        present(modalVC, animated: true, completion: nil)
    }
}
