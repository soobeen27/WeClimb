//
//  GymUseCaseAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class GymUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FetchGymInfoUseCase.self) { resolver in
            FetchGymInfoUseCaseImpl(gymRepository: resolver.resolve(GymRepository.self)!
            )
        }
    }
}
