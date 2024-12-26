//
//  SettingCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class SettingCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let settingVC = SettingVC()
        settingVC.coordinator = self
        navigationController.pushViewController(settingVC, animated: true)
    }
}
