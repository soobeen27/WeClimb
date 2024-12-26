//
//  UserPageCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class UserPageCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let userPageVC = UserPageVC()
        userPageVC.coordinator = self
        navigationController.pushViewController(userPageVC, animated: true)
    }
}
