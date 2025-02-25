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
    
    var onUploadSearchFinish: ((String) -> Void)?
    var onSelectedSearchCell: ((SearchResultItem) -> Void)?
    
    init(navigationController: UINavigationController, builder: SearchBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        let searchVC = SearchVC()
        searchVC.coordinator = self
        
        searchVC.toSearchResult = { [weak self] query in
            self?.navigateToSearchResult(query: query)
        }
        navigationController.pushViewController(searchVC, animated: true)
        
        searchVC.toUploalMediaPost = { [weak self] query in
            self?.onSelectedSearchCell?(query)
        }
    }
    
    func navigateToSearchResult(query: String) {
        let searchResultCoordinator = SearchResultCoordinator(navigationController: navigationController, builder: builder)
        searchResultCoordinator.query = query
        searchResultCoordinator.start()
    }
    
    func navigateToUploadSearch() {
        let searchVC = SearchVC(searchStyle: .uploadSearch)
        searchVC.coordinator = self
        
        searchVC.toUploadSearchResult = { [weak self] query in
            self?.onUploadSearchFinish?(query)
        }
        
        searchVC.toUploalMediaPost = { [weak self] query in
            self?.onSelectedSearchCell?(query)
        }
        navigationController.pushViewController(searchVC, animated: true)
    }
}
