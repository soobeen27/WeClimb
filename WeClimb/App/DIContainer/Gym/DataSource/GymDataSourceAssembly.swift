//
//  GymDataSourceAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class GymDataSourceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GymDataSource.self) { _ in
            GymDataSourceImpl()
        }
    }
}
