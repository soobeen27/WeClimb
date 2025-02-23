//
//  homeGymSettingCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 2/24/25.
//

import UIKit

final class homeGymSettingCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: UserPageBuilder
    
    var onFinish: (() -> Void)?
    
    init(navigationController: UINavigationController, builder: UserPageBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        showUserHomeGymSettingPage()
    }
    
    private func showUserHomeGymSettingPage() {
//        let homeGymSettingPage = builder.buildUserHomeGymSettingPage()
//        homeGymSettingPage.coordinator = self
//        
//        navigationController.pushViewController(homeGymSettingPage, animated: true)
    }
}
