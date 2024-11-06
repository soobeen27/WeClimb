//
//  CommonManager.swift
//  WeClimb
//
//  Created by 강유정 on 9/24/24.
//

import UIKit

class CommonManager {
    static let shared = CommonManager()

    private init() {}
    
    // MARK: - 알럿 YJ
    // (파라미터 순서 → 사용할 뷰컨트롤러, 타이틀, 메세지, 취소 버튼 유무?)
    func showAlert(from viewController: UIViewController, title: String, message: String, includeCancel: Bool = false, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) {_ in 
            completion?()
        })
        
        // 취소 버튼을 추가할 경우
        if includeCancel {
            alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 토스트 메시지 YJ
    // (파라미터 순서 → 메세지, 폰트, 위치?, 시간?)
     func showToast(message: String, font: UIFont, position: CGPoint? = nil, duration: TimeInterval = 4.0) {
         guard let window = UIApplication.shared.keyWindow else { return }
         
         let toastLabel = UILabel(frame: CGRect(x: (window.frame.size.width - 150) / 2,
                                                 y: position?.y ?? (window.frame.size.height - 100),
                                                 width: 150,
                                                 height: 35))
         toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
         toastLabel.textColor = UIColor.white
         toastLabel.font = font
         toastLabel.textAlignment = .center
         toastLabel.text = message
         toastLabel.alpha = 1.0
         toastLabel.layer.cornerRadius = 10
         toastLabel.clipsToBounds = true
         window.addSubview(toastLabel)

         UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
         }, completion: { _ in
             toastLabel.removeFromSuperview()
         })
     }
}
