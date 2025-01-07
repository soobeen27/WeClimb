//
//  TabBarCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class TabBarCoordinator: BaseCoordinator {
    var tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    override func start() {
        setUpTabBar()
    }
    
    private func setUpTabBar() {
        let feedCoordinator = createFeedCoordinator()
        let searchCoordinator = createSearchCoordinator()
        let uploadCoordinator = createUploadCoordinator()
        let notificationCoordinator = createNotificationCoordinator()
        let userPageCoordinator = createUserPageCoordinator()
        
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
    
    // MARK: - Coordinator Factory Methods
    private func createFeedCoordinator() -> FeedCoordinator {
        let navigationController = UINavigationController()
        let coordinator = FeedCoordinator(navigationController: navigationController, builder: <#any FeedBuilder#>)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.homeIcon,
            selectedImage: UIImage.homeIconFill
        )
        return coordinator
    }
    
    private func createSearchCoordinator() -> SearchCoordinator {
        let navigationController = UINavigationController()
        let coordinator = SearchCoordinator(navigationController: navigationController)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.searchIcon,
            selectedImage: UIImage.searchIconFill
        )
        return coordinator
    }
    
    private func createUploadCoordinator() -> UploadCoordinator {
        let navigationController = UINavigationController()
        let coordinator = UploadCoordinator(navigationController: navigationController)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.uploadIcon,
            selectedImage: UIImage.uploadIconFill
        )
        return coordinator
    }
    
    private func createNotificationCoordinator() -> NotificationCoordinator {
        let navigationController = UINavigationController()
        let coordinator = NotificationCoordinator(navigationController: navigationController)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.notificationIcon,
            selectedImage: UIImage.notificationIconFill
        )
        return coordinator
    }
    
    private func createUserPageCoordinator() -> UserPageCoordinator {
        let navigationController = UINavigationController()
        let coordinator = UserPageCoordinator(navigationController: navigationController)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.avatarIcon,
            selectedImage: UIImage.avatarIconFill
        )
        return coordinator
    }
}
