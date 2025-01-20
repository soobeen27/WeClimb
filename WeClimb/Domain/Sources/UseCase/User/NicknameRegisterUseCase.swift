//
//  NicknameRegisterUseCase.swift
//  WeClimb
//
//  Created by 윤대성 on 1/9/25.
//

import Foundation

import RxSwift

protocol NicknameRegisterUseCase {
    func execute(name: String) -> Single<Void>
}

final class NicknameRegisterUseCaseImpl: NicknameRegisterUseCase {
    private let userUpdateRepository: UserUpdateRepository
    
    init(userUpdateRepository: UserUpdateRepository) {
        self.userUpdateRepository = userUpdateRepository
    }
    
    func execute(name: String) -> Single<Void> {
        return userUpdateRepository.updateUser(with: name, for: .userName)
            .andThen(Single.just(()))
    }
}
