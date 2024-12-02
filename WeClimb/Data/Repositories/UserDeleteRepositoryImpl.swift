//
//  UserDeleteRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

final class UserDeleteRepositoryImpl: UserDeleteRepository {
    private let userDeleteDataSource: UserDeleteDataSource
    
    init(userDeleteDataSource: UserDeleteDataSource) {
        self.userDeleteDataSource = userDeleteDataSource
    }
    
    func userDelete() -> Completable {
        return userDeleteDataSource.userDelete()
    }
}
