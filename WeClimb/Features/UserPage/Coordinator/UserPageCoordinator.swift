//
//  UserPageCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 2/6/25.
//

import UIKit

final class UserPageCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: UserPageBuilder
    private var feedCoordinator: FeedChildCoordinator?

    var onFinish: ((UserPageEvent) -> Void)?
    
    init(navigationController: UINavigationController, builder: UserPageBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        showUserPage()
    }
    
    private func showUserPage() {
        let userPageVC = builder.buildUserPage()
        userPageVC.coordinator = self
        
        navigationController.pushViewController(userPageVC, animated: true)
    }
    
    func showFeed(postType: PostType) {
        let feedCoordinator = FeedChildCoordinator(navigationController: navigationController, builder: FeedBuilderImpl())
        self.feedCoordinator = feedCoordinator
        addDependency(feedCoordinator)
        
        feedCoordinator.showFeed(postType: postType)
    }
    
    func handleEvent(_ event: UserPageEvent) {
        onFinish?(event)
    }
}
