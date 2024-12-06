//
//  SNSAgreeUsecase.swift
//  WeClimb
//
//  Created by 머성이 on 12/6/24.
//

import Foundation

import RxSwift

protocol SNSAgreeUsecase {
    func excute<T>(data: T, for field: UserUpdate) -> Completable
}

public struct SNSAgreeUsecaseImpl: SNSAgreeUsecase {
    private let userUpdateRepository: UserUpdateRepository
    
    init(userUpdateRepository: UserUpdateRepository) {
        self.userUpdateRepository = userUpdateRepository
    }
    
    func excute<T>(data: T, for field: UserUpdate) -> Completable {
        return userUpdateRepository.updateUser(with: data, for: field)
    }
}

