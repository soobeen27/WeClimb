//
//  SettingBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol SettingBuilder {
//    func buildSearch() -> SearchVC
//    func buildSearchResult() -> SearchResultVC
}

final class SettingBuilderImpl: SettingBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shared) {
        self.container = container
    }
    
//    func buildSearch() -> SearchVC {
//        let viewModel: SearchVM = container.resolve(SearchVM.self)
//        return SearchVM(viewModel: viewModel)
//    }
//
//    func buildSearchResult() -> SearchResultVC {
//        let viewModel: SearchResultVM = container.resolve(SearchResultVM.self)
//        return SearchResultVC(viewModel: viewModel)
//    }
}
