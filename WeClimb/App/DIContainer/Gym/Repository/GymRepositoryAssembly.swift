//
//  GymRepositoryAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class GymRepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GymRepository.self) { resolver in
            GymRepositoryImpl(gymDataSource: resolver.resolve(GymDataSource.self)!)
        }
    }
}
