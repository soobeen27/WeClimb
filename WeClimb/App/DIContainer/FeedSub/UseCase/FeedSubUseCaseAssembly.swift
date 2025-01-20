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
    }
}
