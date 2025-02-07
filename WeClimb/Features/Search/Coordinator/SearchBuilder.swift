//
//  SearchBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol SearchBuilder {
//    func buildSearch() -> SearchVC
    func buildSearchResult() -> SearchResultVC
    func buildUploadSearchResult() -> SearchResultVC
}

final class SearchBuilderImpl: SearchBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shared) {
        self.container = container
    }
    
//    func buildSearch() -> SearchVC {
//        let viewModel: SearchVM = container.resolve(SearchVM.self)
//        return SearchVC(viewModel: viewModel)
//    }
    
    func buildSearchResult() -> SearchResultVC {
        let viewModel: SearchResultVM = container.resolve(SearchResultVM.self)
        return SearchResultVC(viewModel: viewModel, searchStyle: .defaultSearch)
    }
    
    func buildUploadSearchResult() -> SearchResultVC {
        let viewModel: SearchResultVM = container.resolve(SearchResultVM.self)
        return SearchResultVC(viewModel: viewModel, searchStyle: .uploadSearch)
    }
}
