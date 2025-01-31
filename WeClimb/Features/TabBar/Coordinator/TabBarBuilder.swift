//
//  TabBarBuilder.swift
//  WeClimb
//
//  Created by 윤대성 on 1/10/25.
//

import UIKit

protocol TabBarBuilder {
    func buildFeedCoordinator() -> FeedCoordinator
    func buildSearchCoordinator() -> SearchCoordinator
    func buildUploadCoordinator(tabBarController: UITabBarController) -> UploadCoordinator
    func buildNotificationCoordinator() -> NotificationCoordinator
    func buildUserPageCoordinator() -> UserPageCoordinator
}

final class TabBarBuilderImpl: TabBarBuilder {
    
    private let feedBuilder: FeedBuilder
    private let searchBuilder: SearchBuilder
    private let uploadBuilder: UploadBuilder
    private let notificationBuilder: NotificationBuilder
    private let userPageBuilder: UserPageBuilder
    
    init(feedBuilder: FeedBuilder, searchBuilder: SearchBuilder, uploadBuilder: UploadBuilder, notificationBuilder: NotificationBuilder, userPageBuilder: UserPageBuilder) {
        self.feedBuilder = feedBuilder
        self.searchBuilder = searchBuilder
        self.uploadBuilder = uploadBuilder
        self.notificationBuilder = notificationBuilder
        self.userPageBuilder = userPageBuilder
    }
    
    func buildFeedCoordinator() -> FeedCoordinator {
        let navigationController = UINavigationController()
        let feedBuilder: FeedBuilder = AppDIContainer.shared.resolve(FeedBuilder.self)
        let coordinator = FeedCoordinator(navigationController: navigationController, builder: feedBuilder)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.homeIcon,
            selectedImage: UIImage.homeIconFill
        )
        return coordinator
    }
    
    func buildSearchCoordinator() -> SearchCoordinator {
        let navigationController = UINavigationController()
        let searchBuilder: SearchBuilder = AppDIContainer.shared.resolve(SearchBuilder.self)
        let coordinator = SearchCoordinator(navigationController: navigationController, builder: searchBuilder)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.searchIcon,
            selectedImage: UIImage.searchIconFill
        )
        return coordinator
    }
    
    func buildUploadCoordinator(tabBarController: UITabBarController) -> UploadCoordinator {
        let navigationController = UINavigationController()
        let uploadBuilder: UploadBuilder = AppDIContainer.shared.resolve(UploadBuilder.self)
        let coordinator = UploadCoordinator(navigationController: navigationController, tabBarController: tabBarController, builder: uploadBuilder)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.uploadIcon,
            selectedImage: UIImage.uploadIconFill
        )
        return coordinator
    }
    
    func buildNotificationCoordinator() -> NotificationCoordinator {
        let navigationController = UINavigationController()
        let coordinator = NotificationCoordinator(navigationController: navigationController)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.notificationIcon,
            selectedImage: UIImage.notificationIconFill
        )
        return coordinator
    }
    
    func buildUserPageCoordinator() -> UserPageCoordinator {
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

