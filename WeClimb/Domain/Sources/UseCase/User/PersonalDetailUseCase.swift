//
//  PersonalDetailUseCase.swift
//  WeClimb
//
//  Created by 윤대성 on 1/10/25.
//

import Foundation

import RxSwift

protocol PersonalDetailUseCase {
    func execute(height: Int) -> Completable
    func execute(armReach: Int) -> Completable
}

final class PersonalDetailUseCaseImpl: PersonalDetailUseCase {
    private let userUpdateRepository: UserUpdateRepository
    
    init(userUpdateRepository: UserUpdateRepository) {
        self.userUpdateRepository = userUpdateRepository
    }
    
    func execute(height: Int) -> Completable {
        return userUpdateRepository.updateUser(with: height, for: .height)
    }
    
    func execute(armReach: Int) -> Completable {
        return userUpdateRepository.updateUser(with: armReach, for: .armReach)
    }
}
