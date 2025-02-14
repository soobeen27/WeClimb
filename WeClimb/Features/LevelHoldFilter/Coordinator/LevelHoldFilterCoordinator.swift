//
//  LevelHoldFilterCoordinator.swift
//  WeClimb
//
//  Created by 강유정 on 2/6/25.
//

import UIKit
import RxSwift

final class LevelHoldFilterCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: LevelHoldFilterBuilder
    
    private let disposeBag = DisposeBag()
    
    var gymName: String
    var onLevelHoldFiltersApplied: ((String, String) -> Void)?
    
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
        
        levelHoldFilterVC.onFiltersApplied = { [weak self] levelFilters, holdFilters in
            guard let self = self else { return }
            
            self.onLevelHoldFiltersApplied?(levelFilters, holdFilters)
        }
    }
    
    func startHoldIndex() {
        let levelHoldFilterVC = builder.buildHoldFilterVC(gymName: gymName)
        levelHoldFilterVC.coordinator = self
        levelHoldFilterVC.setFilterViewTheme(theme: .dark)
        
        navigationController.presentCustomHeightModal(modalVC: levelHoldFilterVC, heightRatio: 0.84)
        
        levelHoldFilterVC.onFiltersApplied = { [weak self] levelFilters, holdFilters in
            guard let self = self else { return }
            
            self.onLevelHoldFiltersApplied?(levelFilters, holdFilters)
        }
    }
}
