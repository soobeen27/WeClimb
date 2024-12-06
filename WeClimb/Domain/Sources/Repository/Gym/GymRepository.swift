//
//  GymRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

protocol GymRepository {
    func allGymName() -> Single<[String]>
    func gymInfo(from name: String, completion: @escaping (Gym?) -> Void)
}
