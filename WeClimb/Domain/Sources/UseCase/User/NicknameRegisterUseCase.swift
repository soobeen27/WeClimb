//
//  NicknameRegisterUseCase.swift
//  WeClimb
//
//  Created by 윤대성 on 1/9/25.
//

import Foundation

import RxSwift

protocol NicknameRegisterUseCase {
    func execute(name: String) -> Completable
}

final class NicknameRegisterUseCaseImpl: NicknameRegisterUseCase {
    private let userUpdateRepository: UserUpdateRepository
    
    init(userUpdateRepository: UserUpdateRepository) {
        self.userUpdateRepository = userUpdateRepository
    }
    
    func execute(name: String) -> Completable {
        return userUpdateRepository.updateUser(with: name, for: .userName)
    }
}
