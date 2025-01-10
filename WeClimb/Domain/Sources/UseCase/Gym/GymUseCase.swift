//
//  GymUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 1/8/25.
//

import RxSwift


protocol GymUseCase {
    func gymInfo(gymName: String) -> Single<Gym>
    func allGymInfo() -> Single<[Gym]>
}

class GymUseCaseImpl: GymUseCase {
    private let gymRepository: GymRepository
    
    init(gymRepository: GymRepository) {
        self.gymRepository = gymRepository
    }
    
    func gymInfo(gymName: String) -> Single<Gym> {
        return gymRepository.gymInfo(gymName: gymName)
    }
    
    func allGymInfo() -> Single<[Gym]> {
        return gymRepository.allGymInfo()
    }
}
