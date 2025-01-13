//
//  UserSearchRepositoryImpl.swift
//  WeClimb
//
//  Created by 강유정 on 1/13/25.
//

import RxSwift

protocol UserSearchRepository {
    func searchUsers(with searchText: String) -> Single<[User]>
}

class UserSearchRepositoryImpl: UserSearchRepository {
    private let userSearchDataSource: UserSearchDataSource
    
    init(userSearchDataSource: UserSearchDataSource) {
        self.userSearchDataSource = userSearchDataSource
    }
    
    func searchUsers(with searchText: String) -> Single<[User]> {
        return userSearchDataSource.searchUsers(with: searchText)
    }
}

