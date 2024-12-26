//
//  UploadPostCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class UploadPostCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let uploadPostVC = UploadPostVC()
        uploadPostVC.coordinator = self
        navigationController.pushViewController(uploadPostVC, animated: true)
    }
}
