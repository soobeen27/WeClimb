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
        showFeed()
    }
    private func showFeed() {
        let feedChildCoordinator = FeedChildCoordinator(navigationController: navigationController, builder: builder)
        addDependency(feedChildCoordinator)
        
        feedChildCoordinator.start()
        
        feedChildCoordinator.onFinish = { [weak self] postItem in
            self?.showComment(postItem: postItem)
        }
    }
    
    private func showComment(postItem: PostItem) {
        let commentCoordinator = PostCommentCoordinator(navigationController: navigationController, builder: builder)
        addDependency(commentCoordinator)
        
        commentCoordinator.start(postItem: postItem)

        commentCoordinator.onFinish = { [weak self] in
            self?.removeDependency(commentCoordinator)
        }
    }
}
