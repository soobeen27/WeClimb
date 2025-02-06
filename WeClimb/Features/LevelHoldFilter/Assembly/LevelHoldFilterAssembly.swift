//
//  LevelHoldFilterAssembly.swift
//  WeClimb
//
//  Created by 강유정 on 2/6/25.
//

import Swinject

final class LevelHoldFilterAssembly: Assembly {
    
    func assemble(container: Container) {   
        container.register(GymDataSource.self) { _ in
            GymDataSourceImpl()
        }
        
        container.register(LevelHoldFilterBuilder.self) { resolver in
            LevelHoldFilterBuilderImpl()
        }
        
        container.register(GymRepository.self) { resolver in
            GymRepositoryImpl(gymDataSource: resolver.resolve(GymDataSource.self)!
            )
        }
        
        container.register(FetchGymInfoUseCase.self) { resolver in
            FetchGymInfoUseCaseImpl(gymRepository: resolver.resolve(GymRepository.self)!
            )
        }
        
        container.register(LevelHoldFilterVM.self) { resolver in
            LevelHoldFilterVMImpl(fetchGymInfoUseCase: resolver.resolve(FetchGymInfoUseCase.self)!)
        }
    }
}
