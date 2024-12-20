//
//  SearchCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class SearchCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let searchVC = SearchVC()
        searchVC.coordinator = self
        navigationController.pushViewController(searchVC, animated: true)
    }
}
