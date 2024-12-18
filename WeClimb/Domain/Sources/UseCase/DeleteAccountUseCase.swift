//
//  DeleteAccountUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 11/29/24.
//

import RxSwift

public protocol DeleteAccountUseCase {
    func execute() -> Completable
}

public struct DeleteAccountUseCaseImpl: DeleteAccountUseCase {
    public func execute() -> Completable {
        
        return Completable.create { completable in
            
            FirebaseManager.shared.userDelete { error in
                if let error = error {
                    print("사용자 삭제에 실패: \(error.localizedDescription)")
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
            }
            return Disposables.create()
        }
    }
}
