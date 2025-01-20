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
    var onTabBarPage: (() -> Void)?
    
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
    
    func handleLoginStatus(_ status: LoginStatus) {
        switch status {
        case .tabBar:
            onTabBarPage?()
        case .privacyPolicy:
            onFinish?()
        }
    }
}
