//
//  PostUseCaseAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//
import Swinject

final class PostUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MainFeedUseCase.self) { resolver in
            MainFeedUseCaseImpl(mainFeedRepository: resolver.resolve(MainFeedRepository.self)!)
        }
        
        container.register(FetchMediasUseCase.self) { resolver in
            FetchMediasUseCaseImpl(fetchMediasRepository: resolver.resolve(FetchMediasRepository.self)!)
        }
        container.register(PostDeleteUseCase.self) { resolver in
            PostDeleteUseCaseImpl(postDeleteRepository: resolver.resolve(PostDeleteRepository.self)!)
        }
        container.register(FetchUserFeedInfoUseCase.self) { resolver in
            FetchUserFeedInfoUseCaseImpl(postAggregationRepository:
                resolver.resolve(PostAggregationRepository.self)!)
        }
        container.register(PostFilterUseCase.self) { resolver in
            PostFilterUseCaseImpl(postFilterRepository: resolver.resolve(PostFilterRepository.self)!)
        }
        container.register(PostUseCase.self) { resolver in
            PostUseCaseImpl(postRepository: resolver.resolve(PostRepository.self)!)
        }
    }
}
