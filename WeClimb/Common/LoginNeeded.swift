//
//  LoginNeeded.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/17/24.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginNeeded {
    
    private func navigateToLoginVC() {
        let loginVC = LoginVC()
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = scene.windows.first(where: \.isKeyWindow) {
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
    
    private func showAlert(from viewController: UIViewController, title: String, message: String, includeCancel: Bool = false, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) {_ in
            completion?()
        })
        
        if includeCancel {
            alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// 비로그인이면 로그인 알럿보여주고 bool반환
    /// - Parameter vc: 알럿 보여줄 뷰컨트롤러
    /// - Returns: 비로그인 ->  true 로그인 -> false
    func loginAlert(vc: UIViewController) -> Bool {
        if !isLogin() {
            showAlert(from: vc, title: "비회원입니다.", message: "로그인하시겠습니까?", includeCancel: true) { [weak self] in
                self?.navigateToLoginVC()
            }
            return true
        }
        return false
    }
        
    private func isLogin() -> Bool {
        if let _ = Auth.auth().currentUser{
            return true
        }
        return false
    }
}
