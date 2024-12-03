//
//  UIButton+Extension.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import UIKit

//MARK: - 좋아요 버튼 애니메이션
extension UIButton {
    
    //버튼의 활성화 상태를 나타내는 변수
    private struct AssociatedKeys {
        static var isActivated = "isActivated"
    }
    
    //    var isActivated: Bool {
    //        get {
    //            return objc_getAssociatedObject(self, &AssociatedKeys.isActivated) as? Bool ?? false
    //        }
    //        set {
    //            objc_setAssociatedObject(self, &AssociatedKeys.isActivated, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    //            updateImage()
    //        }
    //    }
    //
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
        let isDarkMode = (traitCollection.userInterfaceStyle == .dark) || (backgroundColor == UIColor(hex: "#0C1014"))
        
//        let tintColor = isDarkMode ? UIColor(hex: "#FFFFFF") : UIColor(hex: "#CDCDCD")
        
        return UIImage(systemName: "heart")?
            .withTintColor(.white)
            .withRenderingMode(.alwaysOriginal)
    }
    
    //버튼의 이미지를 현재 상태에 따라 업데이트
    func updateImage() {
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
