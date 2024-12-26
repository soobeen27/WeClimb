//
//  FeedCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class FeedCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let feedVC = FeedVC()
        feedVC.coordinator = self
        navigationController.pushViewController(feedVC, animated: true)
    }
}
