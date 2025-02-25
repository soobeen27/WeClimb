//
//  FeedBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol FeedBuilder {
    func buildFeed() -> FeedVC
    func buildComment(postItem: PostItem) -> PostCommentVC
}

final class FeedBuilderImpl: FeedBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shared) {
        self.container = container
    }
    
    func buildFeed() -> FeedVC {
        let viewModel: FeedVM = container.resolve(FeedVM.self)
        
        return FeedVC(viewModel: viewModel, postType: .feed)
    }
    
    func buildComment(postItem: PostItem) -> PostCommentVC {
        let viewModel: PostCommentVM = container.resolve(PostCommentVM.self)
        
        return PostCommentVC(viewModel: viewModel, postItem: postItem)
    }
}
