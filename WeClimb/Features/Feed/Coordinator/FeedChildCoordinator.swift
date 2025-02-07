//
//  FeedChildCoordinator.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/5/25.
//

import UIKit

final class FeedChildCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: FeedBuilder
    
    var onFinish: ((PostItem) -> Void)?
    
    init(navigationController: UINavigationController, builder: FeedBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        showFeedVC()
    }
    
    private func showFeedVC() {
        let feedVC = builder.buildFeed()
        feedVC.coordinator = self
        feedVC.commentTapped = { [weak self] postItem in
            self?.onFinish?(postItem)
        }
        navigationController.pushViewController(feedVC, animated: true)
    }
}
