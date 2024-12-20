//
//  ManageBookMarkCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class ManageBookMarkCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let manageBookMarkVC = ManageBookMarkVC()
        manageBookMarkVC.coordinator = self
        navigationController.pushViewController(manageBookMarkVC, animated: true)
    }
}
