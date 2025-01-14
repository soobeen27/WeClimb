//
//  LoginCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class LoginCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: OnboardingBuilder
    
    var onFinish: (() -> Void)?

    init(navigationController: UINavigationController, builder: OnboardingBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        showLogin()
    }
    
    private func showLogin() {
        let loginVC = builder.buildLogin()
        loginVC.coordinator = self
        loginVC.loginButtonSelected = { [weak self] status in
            self?.handleLoginStatus(status)
        }
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    private func handleLoginStatus(_ status: LoginStatus) {
        switch status {
        case .tabBar:
            print("안농") // 탭바 이동
        case .privacyPolicy:
            onFinish?()
        }
    }
}
