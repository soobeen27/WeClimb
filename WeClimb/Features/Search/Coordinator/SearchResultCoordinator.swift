//
//  SearchResultCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class SearchResultCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let searchResultVC = SearchResultVC()
        searchResultVC.coordinator = self
        navigationController.pushViewController(searchResultVC, animated: true)
    }
    
}
