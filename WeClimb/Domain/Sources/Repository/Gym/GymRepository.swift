//
//  GymRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

protocol GymRepository {
    func gymInfo(gymName: String) -> Single<Gym>
    func allGymInfo() -> Single<[Gym]>
    func searchGymsByQuery(with query: String) -> Observable<[Gym]>
}
