//
//  CreatePersonalDetailCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class CreatePersonalDetailCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let createPersonalDetailVC = CreatePersonalDetailVC()
        createPersonalDetailVC.coordinator = self
        navigationController.pushViewController(createPersonalDetailVC, animated: true)
    }
}
