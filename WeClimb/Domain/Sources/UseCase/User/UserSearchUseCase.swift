//
//  UserSearchUseCaseImpl.swift
//  WeClimb
//
//  Created by 강유정 on 1/13/25.
//

import RxSwift

protocol UserSearchUseCase {
    func searchUsers(with searchText: String) -> Single<[User]>
}

class UserSearchUseCaseImpl: UserSearchUseCase {
    private let userSearchRepository: UserSearchRepository
    
    init(userSearchRepository: UserSearchRepository) {
        self.userSearchRepository = userSearchRepository
    }
    
    func searchUsers(with searchText: String) -> Single<[User]> {
        return userSearchRepository.searchUsers(with: searchText)
    }
}
