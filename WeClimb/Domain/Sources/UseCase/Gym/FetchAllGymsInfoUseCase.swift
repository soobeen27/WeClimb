//
//  AllGymsInfoUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 1/13/25.
//

import RxSwift

protocol FetchAllGymsInfoUseCase {
    func execute() -> Single<[Gym]>
}

class FetchAllGymsInfoUseCaseImpl: FetchAllGymsInfoUseCase {
    private let gymRepository: GymRepository
    
    init(gymRepository: GymRepository) {
        self.gymRepository = gymRepository
    }
    
    func execute() -> Single<[Gym]> {
        return gymRepository.allGymInfo()
    }
}
