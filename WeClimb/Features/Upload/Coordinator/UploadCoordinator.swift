//
//  UploadCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class UploadCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let uploadVC = UploadVC()
        uploadVC.coordinator = self
        navigationController.pushViewController(uploadVC, animated: true)
    }
}
