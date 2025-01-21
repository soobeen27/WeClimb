//
//  SearchCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class SearchCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: SearchBuilder
    
    init(navigationController: UINavigationController, builder: SearchBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        let searchVC = builder.buildSearch()
        searchVC.coordinator = self
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func navigateToSearchResult(query: String) {
        let searchResultCoordinator = SearchResultCoordinator(navigationController: navigationController, builder: builder)
        searchResultCoordinator.query = query
        searchResultCoordinator.start()
    }
}
