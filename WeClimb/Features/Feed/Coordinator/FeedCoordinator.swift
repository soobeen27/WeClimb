//
//  FeedCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class FeedCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let feedBuilder: FeedBuilder
    private let gymBuilder: GymBuilder
    
    init(navigationController: UINavigationController, feedBuilder: FeedBuilder, gymBuilder: GymBuilder) {
        self.navigationController = navigationController
        self.gymBuilder = gymBuilder
        self.feedBuilder = feedBuilder
    }
    
    override func start() {
        showFeed()
    }
    private func showFeed() {
        let feedChildCoordinator = FeedChildCoordinator(navigationController: navigationController, builder: feedBuilder)
        addDependency(feedChildCoordinator)
        
        feedChildCoordinator.start()
        
        feedChildCoordinator.onFinish = { [weak self] (pushType : FeedPushType) in
            switch pushType {
            case .comment(let postItem):
                self?.showComment(postItem: postItem)
            case .gym(let gymName, let level, let hold):
                self?.showGym(gymName: gymName, level: level, hold: hold)
            case .user(let userName):
                print("userPage coordinator needed")
            }
            
        }
    }
    
    private func showComment(postItem: PostItem) {
        let commentCoordinator = PostCommentCoordinator(navigationController: navigationController, builder: feedBuilder)
        addDependency(commentCoordinator)
        
        DispatchQueue.main.async {
            commentCoordinator.start(postItem: postItem)
        }
        
        commentCoordinator.onFinish = { [weak self] in
            self?.removeDependency(commentCoordinator)
        }
    }
    
    private func showGym(gymName: String, level: LHColors?, hold: LHColors?) {
        let gymCoordinator = GymCoordinator(navigationController: navigationController, builder: gymBuilder)
        DispatchQueue.main.async {
            gymCoordinator.start(gymName: gymName, level: level, hold: hold)
        }
        
        gymCoordinator.onFinish = { [weak self] in
            self?.removeDependency(gymCoordinator)
        }
        
    }
}
