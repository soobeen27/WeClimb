//
//  LevelHoldFilterBuilder.swift
//  WeClimb
//
//  Created by 강유정 on 2/6/25.
//

import Foundation

protocol LevelHoldFilterBuilder {
    func buildLevelFilterVC(gymName: String) -> LevelHoldFilterVC
    func buildHoldFilterVC(gymName: String) -> LevelHoldFilterVC
}

final class LevelHoldFilterBuilderImpl: LevelHoldFilterBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shared) {
        self.container = container
    }
    
    func buildSearchResult() -> SearchResultVC {
        let viewModel: SearchResultVM = container.resolve(SearchResultVM.self)
        return SearchResultVC(viewModel: viewModel, searchStyle: .defaultSearch)
    }
    
    func buildLevelFilterVC(gymName: String) -> LevelHoldFilterVC {
        let viewModel: LevelHoldFilterVM = container.resolve(LevelHoldFilterVM.self)
        return LevelHoldFilterVC(gymName: gymName, viewModel: viewModel)
    }
    
    func buildHoldFilterVC(gymName: String) -> LevelHoldFilterVC {
        let viewModel: LevelHoldFilterVM = container.resolve(LevelHoldFilterVM.self)
        return LevelHoldFilterVC(gymName: gymName, viewModel: viewModel, filterType: .hold)
    }
}
