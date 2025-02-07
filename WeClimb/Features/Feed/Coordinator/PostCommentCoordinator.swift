//
//  PostCommentCoordinator.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/5/25.
//

import UIKit

final class PostCommentCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: FeedBuilder
    
    var onFinish: (() -> Void)?
    
    init(navigationController: UINavigationController, builder: FeedBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func start(postItem: PostItem) {
        showComment(postItem: postItem)
    }
    
    private func showComment(postItem: PostItem) {
        let commentVC = builder.buildComment(postItem: postItem)
        commentVC.coordinator = self
//        navigationController.presentModal(modalVC: commentVC)
        navigationController.presentCustomHeightModal(modalVC: commentVC,
                                                      heightRatio: CommentConsts.modalHeightRatio, grabber: true)
        
        
    }
}
