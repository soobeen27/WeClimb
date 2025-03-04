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
    func buildUserPageMainCoordinator() -> UserPageMainCoordinator
}

final class TabBarBuilderImpl: TabBarBuilder {
    
    private let feedBuilder: FeedBuilder
    private let searchBuilder: SearchBuilder
    private let uploadBuilder: UploadBuilder
    private let notificationBuilder: NotificationBuilder
    private let userPageBuilder: UserPageBuilder
    private let gymBuilder: GymBuilder
    
    init(feedBuilder: FeedBuilder, searchBuilder: SearchBuilder, uploadBuilder: UploadBuilder, notificationBuilder: NotificationBuilder, userPageBuilder: UserPageBuilder, gymBuilder: GymBuilder) {
        self.feedBuilder = feedBuilder
        self.searchBuilder = searchBuilder
        self.uploadBuilder = uploadBuilder
        self.notificationBuilder = notificationBuilder
        self.userPageBuilder = userPageBuilder
        self.gymBuilder = gymBuilder
    }
    
    func buildFeedCoordinator() -> FeedCoordinator {
        let navigationController = UINavigationController()
        let feedBuilder: FeedBuilder = AppDIContainer.shared.resolve(FeedBuilder.self)
        let coordinator = FeedCoordinator(navigationController: navigationController, feedBuilder: feedBuilder, gymBuilder: gymBuilder)
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
        let searchBuilder: SearchBuilder = AppDIContainer.shared.resolve(SearchBuilder.self)
        let levelHoldFilterBuilder: LevelHoldFilterBuilder = AppDIContainer.shared.resolve(LevelHoldFilterBuilder.self)
        let coordinator = UploadCoordinator(
            navigationController: navigationController,
            tabBarController: tabBarController,
            builder: uploadBuilder,
            searchBuilder: searchBuilder,
            levelHoldFilterBuilder: levelHoldFilterBuilder)
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
    
    func buildUserPageMainCoordinator() -> UserPageMainCoordinator {
        let navigationController = UINavigationController()
        let userPageBuilder: UserPageBuilder = AppDIContainer.shared.resolve(UserPageBuilder.self)
        let coordinator = UserPageMainCoordinator(navigationController: navigationController, builder: userPageBuilder)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.avatarIcon,
            selectedImage: UIImage.avatarIconFill
        )
        return coordinator
    }
}

