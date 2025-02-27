//
//  FeedChildCoordinator.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/5/25.
//

import UIKit

enum FeedPushType {
    case comment(postItem: PostItem)
    case user(userName: String)
    case gym(gymName: String, level: LHColors?, hold: LHColors?)
}

final class FeedChildCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: FeedBuilder
    
//    var onFinish: ((PostItem) -> Void)?
    var onFinish: ((FeedPushType) -> Void)?
    
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
//        feedVC.commentTapped = { [weak self] postItem in
//            self?.onFinish?(postItem)
//        }
        feedVC.onFinish = { [weak self] type in
            self?.onFinish?(type)
        }
        navigationController.pushViewController(feedVC, animated: true)
    }
    
    func showFeed(postType: PostType) {
        let feedVC = builder.buildFeed(postType: postType)
        navigationController.pushViewController(feedVC, animated: true)
    }
}
