//
//  NotificationCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class NotificationCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let pushNotificationVC = PushNotificationVC()
        pushNotificationVC.coordinator = self
        navigationController.pushViewController(pushNotificationVC, animated: true)
    }
}
