//
//  EditNickNameCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class EditNickNameCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let editNickNameVC = EditNickNameVC()
        editNickNameVC.coordinator = self
        navigationController.pushViewController(editNickNameVC, animated: true)
    }
}
