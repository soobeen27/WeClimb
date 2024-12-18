//
//  FeedBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol FeedBuilder {
//    func buildFeed() -> FeedVC
}

final class FeedBuilderImpl: FeedBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shard) {
        self.container = container
    }
    
//    func buildFeed() -> FeedVC {
//        let viewModel: FeedVM = container.resolve(FeedVM.self)
//        return FeedVC(viewModel: viewModel)
//    }
}
