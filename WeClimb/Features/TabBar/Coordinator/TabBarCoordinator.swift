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
        let feedCoordinator = FeedCoordinator(navigationController: UINavigationController())
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        let uploadCoordinator = UploadCoordinator(navigationController: UINavigationController())
        let notificationCoordinator = NotificationCoordinator(navigationController: UINavigationController())
        let userPageCoordinator = UserPageCoordinator(navigationController: UINavigationController())
        
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
        let coordinator = FeedCoordinator(navigationController: navigationController)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.customImage(style: .feed),
            selectedImage: UIImage.customImage(style: .feedFill)
        )
        return coordinator
    }
    
    private func createSearchCoordinator() -> SearchCoordinator {
        let navigationController = UINavigationController()
        let coordinator = SearchCoordinator(navigationController: navigationController)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.customImage(style: .serach),
            selectedImage: UIImage.customImage(style: .serachFill)
        )
        return coordinator
    }
    
    private func createUploadCoordinator() -> UploadCoordinator {
        let navigationController = UINavigationController()
        let coordinator = UploadCoordinator(navigationController: navigationController)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.customImage(style: .upload),
            selectedImage: UIImage.customImage(style: .uploadFill)
        )
        return coordinator
    }
    
    private func createNotificationCoordinator() -> NotificationCoordinator {
        let navigationController = UINavigationController()
        let coordinator = NotificationCoordinator(navigationController: navigationController)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.customImage(style: .notification),
            selectedImage: UIImage.customImage(style: .notificationFill)
        )
        return coordinator
    }
    
    private func createUserPageCoordinator() -> UserPageCoordinator {
        let navigationController = UINavigationController()
        let coordinator = UserPageCoordinator(navigationController: navigationController)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.customImage(style: .userPage),
            selectedImage: UIImage.customImage(style: .userPageFill)
        )
        return coordinator
    }
}
