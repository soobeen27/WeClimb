//
//  EditPageCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class EditPageCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let editPageVC = EditPageVC()
        editPageVC.coordinator = self
        navigationController.pushViewController(editPageVC, animated: true)
    }
}
