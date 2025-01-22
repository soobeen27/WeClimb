//
//  UserSearchRepository.swift
//  WeClimb
//
//  Created by 강유정 on 1/21/25.
//

import RxSwift

class UserSearchRepositoryImpl: UserSearchRepository {
    private let userSearchDataSource: UserSearchDataSource
    
    init(userSearchDataSource: UserSearchDataSource) {
        self.userSearchDataSource = userSearchDataSource
    }
    
    func searchUsers(with searchText: String) -> Single<[User]> {
        return userSearchDataSource.searchUsers(with: searchText)
    }
}
