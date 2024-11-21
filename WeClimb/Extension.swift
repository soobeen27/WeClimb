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

extension String {
    var colorInfo: (text: String, englishText: String, color: UIColor) {
        switch self {
        case "빨", "Red":
            return ("빨강", "Red", UIColor(red: 224/255, green: 53/255, blue: 53/255, alpha: 1))
        case "주", "Orange":
            return ("주황", "Orange", UIColor(red: 253/255, green: 150/255, blue: 68/255, alpha: 1))
        case "노", "Yellow":
            return ("노랑", "Yellow", UIColor(red: 255/255, green: 235/255, blue: 26/255, alpha: 1))
        case "연", "LightGreen":
            return ("연두", "LightGreen", UIColor(red: 30/255, green: 212/255, blue: 90/255, alpha: 1))
        case "초", "Green":
            return ("초록", "Green", UIColor(red: 26/255, green: 120/255, blue: 14/255, alpha: 1))
        case "하", "SkyBlue":
            return ("하늘", "SkyBlue", UIColor(red: 19/255, green: 149/255, blue: 255/255, alpha: 1))
        case "파", "Blue":
            return ("파랑", "Blue", UIColor(red: 35/255, green: 97/255, blue: 243/255, alpha: 1))
        case "남", "Indigo":
            return ("남색", "Indigo", UIColor(red: 15/255, green: 0/255, blue: 177/255, alpha: 1))
        case "보", "Purple":
            return ("보라", "Purple", UIColor(red: 160/255, green: 83/255, blue: 233/255, alpha: 1))
        case "검", "Black":
            return ("검정", "Black", UIColor(red: 11/255, green: 16/255, blue: 19/255, alpha: 1))
        case "흰", "White":
            return ("흰색", "White", UIColor(red: 241/255, green: 239/255, blue: 239/255, alpha: 1))
        case "민", "Mint":
            return ("민트", "Mint", UIColor(red: 31/255, green: 223/255, blue: 213/255, alpha: 1))
        case "회", "Gray":
            return ("회색", "Gray", UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1))
        case "핑", "Pink":
            return ("핑크", "Pink", UIColor(red: 255/255, green: 88/255, blue: 188/255, alpha: 1))
        case "갈", "Brown":
            return ("갈색", "Brown", UIColor(red: 187/255, green: 120/255, blue: 58/255, alpha: 1))
        case "노검", "DarkYellow":
            return ("노랑", "DarkYellow", UIColor(red: 133/255, green: 125/255, blue: 23/255, alpha: 1))
        case "초검", "DarkGreen":
            return ("초록", "DarkGreen", UIColor(red: 21/255, green: 114/255, blue: 55/255, alpha: 1))
        case "파검", "DarkBlue":
            return ("파랑", "DarkBlue", UIColor(red: 6/255, green: 103/255, blue: 121/255, alpha: 1))
        default:
            return ("기타", "Other", UIColor.clear)
        }
    }
    
    var getGradeArray: [String] {
        return self.components(separatedBy: ", ")
    }
    
    func colorTextChange() -> String {
        let colorMap: [String: String] = [
            "빨": "빨강",
            "주": "주황",
            "노": "노랑",
            "연": "연두",
            "초": "초록",
            "하": "하늘",
            "파": "파랑",
            "남": "남색",
            "보": "보라",
            "검": "검정",
            "흰": "흰색",
            "민": "민트",
            "회": "회색",
            "핑": "핑크",
            "갈": "갈색",
            "노검": "노랑검정",
            "초검": "초록검정",
            "파검": "파랑검정",
        ]
        return colorMap[self] ?? self
    }
}
    
extension UIImage {
    /// 지정된 크기로 리사이즈한 새로운 UIImage 객체 반환
    /// - Parameter targetSize: 리사이즈할 목표 크기를 나타내는 CGSize.
    /// - Returns: 리사이즈된 UIImage 객체 반환. (실패시 nil 반환)
    func resize(targetSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
