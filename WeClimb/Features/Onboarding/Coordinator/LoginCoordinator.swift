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
    
    init(navigationController: UINavigationController, builder: OnboardingBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        let loginVC = builder.buildLogin()
        loginVC.coordinator = self
        navigationController.pushViewController(loginVC, animated: true)
    }
}
