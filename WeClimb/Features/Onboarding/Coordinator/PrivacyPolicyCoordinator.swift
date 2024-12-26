//
//  PrivacyPolicyCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class PrivacyPolicyCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let privacyPolicyVC = PrivacyPolicyVC()
        privacyPolicyVC.coordinator = self
        navigationController.pushViewController(privacyPolicyVC, animated: true)
    }
}
