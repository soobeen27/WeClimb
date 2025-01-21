//
//  UserSearchRepository.swift
//  WeClimb
//
//  Created by 강유정 on 1/21/25.
//

import RxSwift

protocol UserSearchRepository {
    func searchUsers(with searchText: String) -> Single<[User]>
}
