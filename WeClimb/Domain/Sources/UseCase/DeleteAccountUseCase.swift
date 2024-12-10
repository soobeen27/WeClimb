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
        print("메서드 호출")
        
        return Completable.create { completable in
            print("계정 삭제 시작.")
            
            FirebaseManager.shared.userDelete { error in
                if let error = error {
                    print("사용자 삭제에 실패: \(error.localizedDescription)")
                    completable(.error(error))
                } else {
                    print("사용자 삭제 완료")
                    completable(.completed)
                }
            }
            return Disposables.create()
        }
    }
}
