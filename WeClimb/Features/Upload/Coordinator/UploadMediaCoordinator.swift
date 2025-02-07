//
//  UploadMediaCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class UploadMediaCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let gymItem: SearchResultItem

    var holdFilterGymName: ((String) -> String)?
    var LevelFilterGymName: ((String) -> String)?
    
    init(navigationController: UINavigationController, gymItem: SearchResultItem) {
        self.navigationController = navigationController
        self.gymItem = gymItem
    }
    
    override func start() {
        let uploadVM = UploadVM()
        let uploadMediaVC = UploadMediaVC(gymItem: gymItem, viewModel: uploadVM)
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
    }
    
    private func handleBackButtonTapped() {
        navigationController.popViewController(animated: true)
    }
}
