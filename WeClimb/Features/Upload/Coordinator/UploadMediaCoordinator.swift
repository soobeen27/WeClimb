//
//  UploadMediaCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class UploadMediaCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let uploadMediaVC = UploadMediaVC()
        uploadMediaVC.coordinator = self
        navigationController.pushViewController(uploadMediaVC, animated: true)
    }
}
