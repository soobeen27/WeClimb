//
//  BlackListCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class BlackListCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let blackListVC = BlackListVC()
        blackListVC.coordinator = self
        navigationController.pushViewController(blackListVC, animated: true)
    }
}
