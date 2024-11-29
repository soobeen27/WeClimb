//
//  DeleteAccountUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 11/29/24.
//

import Foundation

public protocol DeleteAccountUseCase {
    func execute(deleteData: Bool) -> Completable
}

public struct DeleteAccountUseCaseImpl {
    
}
