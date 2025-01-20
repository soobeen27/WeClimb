//
//  Untitled.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/16/25.
//
import Foundation

import RxSwift

protocol UserInfoFromUIDUseCase {
    func execute(uid: String) -> Single<User>
}

public struct UserInfoFromUIDUseCaseImpl: UserInfoFromUIDUseCase {
    private let userReadRepository: UserReadRepository
    
    init(userReadRepository: UserReadRepository) {
        self.userReadRepository = userReadRepository
    }
    
    func execute(uid: String) -> Single<User> {
        return userReadRepository.getUserInfoFromUID(byUID: uid)
    }
}
