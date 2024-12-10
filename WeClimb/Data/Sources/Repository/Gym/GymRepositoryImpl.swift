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
    func gymInfo(gymName: String) -> RxSwift.Single<Gym> {
        return gymDataSource.gymInfo(gymName: gymName)
    }
    
    func allGymInfo() -> RxSwift.Single<[Gym]> {
        return gymDataSource.allGymInfo()
    }
}
