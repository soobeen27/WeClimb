//
//  AddBlackListUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/11/25.
//
import RxSwift

protocol AddBlackListUseCase {
    func execute(blockedUser: String) -> Single<Void>
}

struct AddBlackListUseCaseImpl: AddBlackListUseCase {
    private let userBlockRepository: UserBlockRepository
    
    init(userBlockRepository: UserBlockRepository) {
        self.userBlockRepository = userBlockRepository
    }
    
    func execute(blockedUser: String) -> Single<Void> {
        userBlockRepository.addBlackList(blockedUser: blockedUser)
    }
}
