//
//  SearchResultCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class SearchResultCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: SearchBuilder
    var query: String?
    
    init(navigationController: UINavigationController, builder: SearchBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        let searchResultVC = builder.buildSearchResult()
        searchResultVC.coordinator = self
        searchResultVC.query = query
        navigationController.pushViewController(searchResultVC, animated: true)
    }
    
    func navigateBackToSearchVC() {
        navigationController.popViewController(animated: true)
    }
    
    func navigateToUploadSearchResult() {
        let searchResultVC = builder.buildUploadSearchResult()
        searchResultVC.coordinator = self
        searchResultVC.query = query
        navigationController.pushViewController(searchResultVC, animated: true)
    }
}
