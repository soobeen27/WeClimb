//
//  UserSearchUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 1/21/25.
//

import RxSwift

protocol UserSearchUseCase {
    func execute(with searchText: String) -> Single<[User]>
}

class UserSearchUseCaseImpl: UserSearchUseCase {
    private let userSearchRepository: UserSearchRepository
    
    init(userSearchRepository: UserSearchRepository) {
        self.userSearchRepository = userSearchRepository
    }
    
    func execute(with searchText: String) -> Single<[User]> {
        return userSearchRepository.searchUsers(with: searchText)
    }
}
