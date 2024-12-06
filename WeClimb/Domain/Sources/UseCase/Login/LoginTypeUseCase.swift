//
//  LoginTypeUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 12/6/24.
//

import RxSwift

public protocol LoginTypeUseCase {
    func execute() -> Observable<LoginType>
}

public struct LoginTypeUseCaseImpl: LoginTypeUseCase {
    private let loginTypeRepository: LoginTypeRepository

    init(loginTypeRepository: LoginTypeRepository) {
        self.loginTypeRepository = loginTypeRepository
    }

    public func execute() -> Observable<LoginType> {
        return Observable.just(loginTypeRepository.getLoginType())
    }
}
