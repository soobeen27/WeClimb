//
//  UploadPostCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class UploadPostCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: UploadBuilder
    
    private let gymName: String
//    private let mediaItems: [MediaUploadData]
    
    init(navigationController: UINavigationController, gymName: String, builder: UploadBuilder) {
        self.navigationController = navigationController
        self.gymName = gymName
        self.builder = builder
    }
    
    override func start() {
        let uploadPostVC = builder.buildUploadPost(gymName: gymName)
        uploadPostVC.coordinator = self
        navigationController.pushViewController(uploadPostVC, animated: true)
    }
}
