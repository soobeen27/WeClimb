//
//  LogoutUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 11/29/24.
//

import RxSwift

public protocol LogoutUseCaseProtocol {
    func executeLogout() -> Observable<Void>
}

public struct LogoutUseCase {
    
}
