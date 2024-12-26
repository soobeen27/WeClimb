//
//  EditPersonalDetailsCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class EditPersonalDetailsCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let editPersonalDetailsVC = EditPersonalDetailsVC()
        editPersonalDetailsVC.coordinator = self
        navigationController.pushViewController(editPersonalDetailsVC, animated: true)
    }
}
