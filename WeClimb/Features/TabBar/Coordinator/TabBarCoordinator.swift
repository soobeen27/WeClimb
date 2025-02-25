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
    private var customView: UIView?

    private var uploadCoordinator: UploadCoordinator?

    init(tabBarController: UITabBarController, navigationController: UINavigationController, builder: TabBarBuilder) {
        self.tabBarController = tabBarController
        self.navigationController = navigationController
        self.builder = builder
    }

    override func start() {
        setUpTabBar()
        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)

        addTabBarGestureRecognizer()
    }

    private func setUpTabBar() {
        let feedCoordinator = builder.buildFeedCoordinator()
        let searchCoordinator = builder.buildSearchCoordinator()
        let uploadCoordinator = builder.buildUploadCoordinator(tabBarController: tabBarController)
        let notificationCoordinator = builder.buildNotificationCoordinator()
        let userPageMainCoordinator = builder.buildUserPageMainCoordinator()

        self.uploadCoordinator = uploadCoordinator

        addDependency(feedCoordinator)
        addDependency(searchCoordinator)
        addDependency(uploadCoordinator)
        addDependency(notificationCoordinator)
        addDependency(userPageMainCoordinator)
        
        feedCoordinator.start()
        searchCoordinator.start()
//        uploadCoordinator.start()
        notificationCoordinator.start()
        userPageMainCoordinator.start()
        
        tabBarController.viewControllers = [
            feedCoordinator.navigationController,
            searchCoordinator.navigationController,
            uploadCoordinator.navigationController,
            notificationCoordinator.navigationController,
            userPageMainCoordinator.navigationController
        ]
    }
    
    private func addTabBarGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTabBarTap(_:)))
        tabBarController.tabBar.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTabBarTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: tabBarController.tabBar)
        
        guard let items = tabBarController.tabBar.items else { return }
        
        let itemViews = tabBarController.tabBar.subviews.compactMap { $0 as? UIControl }
        
        for (index, _) in items.enumerated() {
            guard index < itemViews.count else { continue }
            
            let itemView = itemViews[index]
            if itemView.frame.contains(location) {
                if index == 2 {
                    if let uploadCoordinator = uploadCoordinator, uploadCoordinator.isUploadViewPresented {
                        uploadCoordinator.dismissUploadMenuView()
                    } else {
                        uploadCoordinator?.start()
                    }
                } else {
                    tabBarController.selectedIndex = index
                    return
                }
            }
        }
    }
}
