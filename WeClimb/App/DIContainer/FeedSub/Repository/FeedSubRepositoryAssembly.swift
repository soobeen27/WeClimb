//
//  FeedSubRepositoryAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class FeedSubRepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CommentRepository.self) { resolver in
            CommentRepositoryImpl(commentDataSource: resolver.resolve(CommentDataSource.self)!)
        }
        
        container.register(LikePostRepository.self) { resolver in
            LikePostRepositoryImpl(likePostDataSource: resolver.resolve(LikePostDataSource.self)!)
        }
    }
}
