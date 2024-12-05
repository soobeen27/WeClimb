//
//  DeleteAccountUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 11/29/24.
//

import Foundation

public protocol DeleteAccountUseCase {
    func execute(completion: @escaping (Bool) -> Void)
}

public struct DeleteAccountUseCaseImpl: DeleteAccountUseCase {
    public func execute(completion: @escaping (Bool) -> Void) {
        FirebaseManager.shared.userDelete { error in
            if let error = error {
                print("사용자 삭제에 실패: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}

