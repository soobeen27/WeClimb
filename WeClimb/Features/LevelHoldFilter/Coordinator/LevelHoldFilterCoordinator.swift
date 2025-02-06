//
//  LevelHoldFilterCoordinator.swift
//  WeClimb
//
//  Created by 강유정 on 2/6/25.
//

import UIKit

final class LevelHoldFilterCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: LevelHoldFilterBuilder
    
    var gymName: String
    
    init(navigationController: UINavigationController, builder: LevelHoldFilterBuilder, gymName: String) {
        self.navigationController = navigationController
        self.builder = builder
        self.gymName = gymName
    }
    
    override func start() {
        let levelHoldFilterVC = builder.buildLevelFilterVC(gymName: gymName)
        levelHoldFilterVC.coordinator = self
        levelHoldFilterVC.setFilterViewTheme(theme: .dark)
        
        navigationController.presentCustomHeightModal(modalVC: levelHoldFilterVC, heightRatio: 0.84)
    }
    
    func startHoldIndex() {
        let levelHoldFilterVC = builder.buildHoldFilterVC(gymName: gymName)
        levelHoldFilterVC.coordinator = self
        levelHoldFilterVC.setFilterViewTheme(theme: .dark)
        
        navigationController.presentCustomHeightModal(modalVC: levelHoldFilterVC, heightRatio: 0.84)
    }
}
