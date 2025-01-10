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
    }
}
