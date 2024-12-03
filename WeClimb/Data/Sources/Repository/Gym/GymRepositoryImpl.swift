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
    
    func allGymName() -> Single<[String]> {
        return gymDataSource.allGymName()
    }
    
    func gymInfo(from name: String, completion: @escaping (Gym?) -> Void) {
        return gymDataSource.gymInfo(from: name) { gym in
            completion(gym)
        }
    }
}
