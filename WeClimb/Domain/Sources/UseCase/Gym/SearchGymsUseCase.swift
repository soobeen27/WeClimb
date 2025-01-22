//
//  Fetch.swift
//  WeClimb
//
//  Created by 강유정 on 1/22/25.
//

import RxSwift

protocol SearchGymsUseCase {
    func execute(query: String) -> Observable<[Gym]>
}

final class SearchGymsUseCaseImpl: SearchGymsUseCase {
    private let gymRepository: GymRepository

    init(gymRepository: GymRepository) {
        self.gymRepository = gymRepository
    }

    func execute(query: String) -> Observable<[Gym]> {
        return gymRepository.searchGymsByQuery(with: query)
    }
}

