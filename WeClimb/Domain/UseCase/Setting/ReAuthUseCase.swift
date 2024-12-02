//
//  ReAuthUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 12/2/24.
//

import RxSwift
import AuthenticationServices

public protocol ReAuthUseCaseProtocol {
    func execute() -> Observable<Bool>
}

public struct ReAuthUseCase: ReAuthUseCaseProtocol {
    private let snsAuthVM = SNSAuthVM()  // 여기서 직접 초기화

    public func execute() -> Observable<Bool> {
        return Observable.create { observer in
            // 애플 로그인만 처리
            self.snsAuthVM.appleLogin(delegate: self.snsAuthVM as! ASAuthorizationControllerDelegate, provider: self.snsAuthVM as! ASAuthorizationControllerPresentationContextProviding)
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

