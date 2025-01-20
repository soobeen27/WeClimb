//
//  GymUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 1/8/25.
//

import RxSwift

protocol FetchGymInfoUseCase {
    func execute(gymName: String) -> Single<Gym>
}

class FetchGymInfoUseCaseImpl: FetchGymInfoUseCase {
    private let gymRepository: GymRepository
    
    init(gymRepository: GymRepository) {
        self.gymRepository = gymRepository
    }
    
    func execute(gymName: String) -> Single<Gym> {
        return gymRepository.gymInfo(gymName: gymName)
    }
}
