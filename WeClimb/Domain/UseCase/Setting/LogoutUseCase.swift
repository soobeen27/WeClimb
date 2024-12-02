//
//  LogoutUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 11/29/24.
//

import RxSwift
import FirebaseAuth

public protocol LogoutUseCase {
    func execute() -> Observable<Void>
}

public struct LogoutUseCaseImpl: LogoutUseCase {
    
    public func executeLogout() -> Observable<Void> {
        return Observable.create { observer in
            do {
                try Auth.auth().signOut()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
