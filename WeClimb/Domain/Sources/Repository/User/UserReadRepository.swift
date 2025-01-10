//
//  UserReadRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

protocol UserReadRepository {
    func getUserInfoFromUID(byUID uid: String) -> Single<User>
    func getUserInfoFromName(byName name: String) -> Single<User>
    func getMyUserInfo() -> Single<User?>
}
