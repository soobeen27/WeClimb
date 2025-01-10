//
//  UserReadRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

final class UserReadRepositoryImpl: UserReadRepository {
    private let userReadDataSource: UserReadDataSource
    
    init(userReadDataSource: UserReadDataSource) {
        self.userReadDataSource = userReadDataSource
    }
    
    func getUserInfoFromUID(byUID uid: String) -> Single<User> {
        return userReadDataSource.userInfoFromUID(uid: uid)
    }
    
    func getUserInfoFromName(byName name: String) -> Single<User> {
        return userReadDataSource.userInfoFromName(name: name)
    }
    
    func getMyUserInfo() -> Single<User?> {
        return userReadDataSource.myInfo()
    }
}
