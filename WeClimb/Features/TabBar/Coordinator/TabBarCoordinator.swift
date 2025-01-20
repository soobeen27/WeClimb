//
//  TabBarCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class TabBarCoordinator: BaseCoordinator {
    private let tabBarController: UITabBarController
    private let navigationController: UINavigationController
    private let builder: TabBarBuilder
    
    init(tabBarController: UITabBarController, navigationController: UINavigationController, builder: TabBarBuilder) {
        self.tabBarController = tabBarController
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        setUpTabBar()
        navigationController.setViewControllers([tabBarController], animated: true)

    }
    
    private func setUpTabBar() {
        let feedCoordinator = builder.buildFeedCoordinator()
        let searchCoordinator = builder.buildSearchCoordinator()
        let uploadCoordinator = builder.buildUploadCoordinator()
        let notificationCoordinator = builder.buildNotificationCoordinator()
        let userPageCoordinator = builder.buildUserPageCoordinator()
        
        addDependency(feedCoordinator)
        addDependency(searchCoordinator)
        addDependency(uploadCoordinator)
        addDependency(notificationCoordinator)
        addDependency(userPageCoordinator)
        
        feedCoordinator.start()
        searchCoordinator.start()
        uploadCoordinator.start()
        notificationCoordinator.start()
        userPageCoordinator.start()
        
        tabBarController.viewControllers = [
            feedCoordinator.navigationController,
            searchCoordinator.navigationController,
            uploadCoordinator.navigationController,
            notificationCoordinator.navigationController,
            userPageCoordinator.navigationController
        ]
    }
}
