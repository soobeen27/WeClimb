//
//  GymRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

final class GymRepositoryImpl: GymRepository {
    private let gymDataSource: GymDataSource
    
    init(gymDataSource: GymDataSource) {
        self.gymDataSource = gymDataSource
    }
    
    func gymInfo(gymName: String) -> Single<Gym> {
        return gymDataSource.gymInfo(gymName: gymName)
    }
    
    func allGymInfo() -> Single<[Gym]> {
        return gymDataSource.allGymInfo()
    }
    
    func searchGymsByQuery(with query: String) -> Observable<[Gym]> {
        return gymDataSource.searchGyms(with: query)
    }
}
