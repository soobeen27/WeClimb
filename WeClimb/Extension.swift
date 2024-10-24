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
        let isDarkMode = (traitCollection.userInterfaceStyle == .dark) || (backgroundColor == UIColor(hex: "#0C1014"))

        let tintColor = isDarkMode ? UIColor(hex: "#FFFFFF") : UIColor(hex: "#CDCDCD")

        return UIImage(systemName: "heart")?
            .withTintColor(tintColor)
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
}

extension String {
    var colorInfo: (text: String, color: UIColor) {
        switch self {
        case "빨":
            return ("빨강", UIColor(red: 224/255, green: 53/255, blue: 53/255, alpha: 1))
        case "주":
            return ("주황", UIColor(red: 253/255, green: 150/255, blue: 68/255, alpha: 1))
        case "노":
            return ("노랑", UIColor(red: 255/255, green: 235/255, blue: 26/255, alpha: 1))
        case "초":
            return ("초록", UIColor(red: 30/255, green: 212/255, blue: 90/255, alpha: 1))
        case "파":
            return ("파랑", UIColor(red: 0/255, green: 189/255, blue: 222/255, alpha: 1))
        case "남":
            return ("남색", UIColor(red: 40/255, green: 100/255, blue: 240/255, alpha: 1))
        case "보":
            return ("보라", UIColor(red: 160/255, green: 83/255, blue: 233/255, alpha: 1))
        case "검":
            return ("검정", UIColor(red: 11/255, green: 16/255, blue: 19/255, alpha: 1))
        case "흰":
            return ("흰색", UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
        case "회":
            return ("회색", UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1))
        case "핑":
            return ("핑크", UIColor(red: 255/255, green: 88/255, blue: 188/255, alpha: 1))
        case "갈":
            return ("갈색", UIColor(red: 187/255, green: 120/255, blue: 58/255, alpha: 1))
        case "하":
            return ("하늘", UIColor(red: 0/255, green: 189/255, blue: 222/255, alpha: 1)) // "파"랑 같은 색
        case "노검":
            return ("노랑", UIColor(red: 133/255, green: 125/255, blue: 23/255, alpha: 1))
        case "초검":
            return ("초록", UIColor(red: 21/255, green: 114/255, blue: 55/255, alpha: 1))
        case "파검":
            return ("파랑", UIColor(red: 6/255, green: 103/255, blue: 121/255, alpha: 1))
        default:
            return ("그 외", UIColor.clear)
        }
    }
}
