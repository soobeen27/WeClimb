//
//  FeedCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class FeedCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: FeedBuilder
    
    init(navigationController: UINavigationController, builder: FeedBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        let feedVC = builder.buildFeed()
        feedVC.coordinator = self
        navigationController.pushViewController(feedVC, animated: true)
    }
}
