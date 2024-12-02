//
//  UserBlockRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

protocol UserBlockRepository {
    func addBlackList(blockedUser uid: String) -> Single<Void>
    func removeBlackList(blockedUser uid: String) -> Single<Void>
}
