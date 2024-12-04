//
//  DeleteAccountUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 11/29/24.
//

import RxSwift

public protocol DeleteAccountUseCase {
    func execute() -> Observable<Void>
}

public struct DeleteAccountUseCaseImpl: DeleteAccountUseCase {
    
    public func execute() -> Observable<Void> {
        return Observable.create { observer in
            FirebaseManager.shared.userDelete { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

