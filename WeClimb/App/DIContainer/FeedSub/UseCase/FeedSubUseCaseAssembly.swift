//
//  FeedSubUseCaseAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class FeedSubUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LikePostUseCase.self) { resolver in
            LikePostUseCaseImpl(likePostRepository: resolver.resolve(LikePostRepository.self)!)
        }
        
        container.register(AddCommentUseCase.self) { resolver in
            AddCommentUseCaseImpl(commentRepository: resolver.resolve(CommentRepository.self)!)
        }
        
        container.register(FetchCommentUseCase.self) { resolver in
            FetchCommentUseCaseImpl(commentRepository: resolver.resolve(CommentRepository.self)!)
        }
        
        container.register(DeleteCommentUseCase.self) { resolver in
            DeleteCommentUseCaseImpl(commentRepository: resolver.resolve(CommentRepository.self)!)
        }
    }
}
