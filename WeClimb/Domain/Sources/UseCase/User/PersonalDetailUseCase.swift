//
//  PersonalDetailUseCase.swift
//  WeClimb
//
//  Created by 윤대성 on 1/10/25.
//

import Foundation

import RxSwift

protocol PersonalDetailUseCase {
    func execute(height: String) -> Completable
    func execute(armReach: String) -> Completable
}

final class PersonalDetailUseCaseImpl: PersonalDetailUseCase {
    private let userUpdateRepository: UserUpdateRepository
    
    init(userUpdateRepository: UserUpdateRepository) {
        self.userUpdateRepository = userUpdateRepository
    }
    
    func execute(height: String) -> Completable {
        return userUpdateRepository.updateUser(with: height, for: .height)
    }
    
    func execute(armReach: String) -> Completable {
        return userUpdateRepository.updateUser(with: armReach, for: .armReach)
    }
}
