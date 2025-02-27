//
//  UploadMediaCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class UploadMediaCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: UploadBuilder
    
    private let gymItem: SearchResultItem

    var holdFilterGymName: ((String) -> String)?
    var LevelFilterGymName: ((String) -> String)?
    
    var onLevelHoldFiltersApplied: ((String, String) -> Void)?
    
    var onFinish: (([MediaUploadData]) -> Void)?
    
    var onDismiss: (() -> Void)?
    
    init(navigationController: UINavigationController, gymItem: SearchResultItem, builder: UploadBuilder) {
        self.navigationController = navigationController
        self.gymItem = gymItem
        self.builder = builder
    }
    
    override func start() {
        let uploadMediaVC = builder.buildUploadMedia(gymItem: gymItem)
        uploadMediaVC.coordinator = self
        
        uploadMediaVC.onBackButton = { [weak self] in
            self?.handleBackButtonTapped()
        }
        
        navigationController.pushViewController(uploadMediaVC, animated: true)
        
        uploadMediaVC.onLevelFilter = { [weak self] gymName in
            self?.LevelFilterGymName?(gymName) ?? ""
        }
        
        uploadMediaVC.onHoldFilter = { [weak self] gymName in
            self?.holdFilterGymName?(gymName) ?? ""
        }
        
        uploadMediaVC.onNextButton = { [weak self] mediaData in
            self?.onFinish?(mediaData)
        }
        
        uploadMediaVC.onDismiss = { [weak self] in
            self?.onDismiss?()
        }
    }
    
    private func handleBackButtonTapped() {
        navigationController.popViewController(animated: true)
    }
}
