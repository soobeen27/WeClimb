//
//  RegisterResultCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class RegisterResultCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let registerResultVC = RegisterResultVC()
        registerResultVC.coordinator = self
        navigationController.pushViewController(registerResultVC, animated: true)
    }
}
