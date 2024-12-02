//
//  ReAuthUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 12/2/24.
//

import RxSwift
import AuthenticationServices

public protocol ReAuthUseCase {
    func execute() -> Observable<Bool>
}

public struct ReAuthUseCaseImpl: ReAuthUseCase {
    private let snsAuthVM = SNSAuthVM()

    public func execute() -> Observable<Bool> {
        return Observable.create { observer in
            self.snsAuthVM.appleLogin(delegate: self.snsAuthVM as! ASAuthorizationControllerDelegate, provider: self.snsAuthVM as! ASAuthorizationControllerPresentationContextProviding)
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

