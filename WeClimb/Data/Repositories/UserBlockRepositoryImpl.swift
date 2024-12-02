//
//  UserBlockRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

final class UserBlockRepositoryImpl: UserBlockRepository {
    private let userBlockDataSource: UserBlockDataSource
    
    init(userBlockDataSource: UserBlockDataSource) {
        self.userBlockDataSource = userBlockDataSource
    }
    
    func addBlackList(blockedUser uid: String) -> Single<Void> {
        return userBlockDataSource.addBlackList(blockedUser: uid)
    }
    
    func removeBlackList(blockedUser uid: String) -> Single<Void> {
        return userBlockDataSource.removeBlackList(blockedUser: uid)
    }
}
