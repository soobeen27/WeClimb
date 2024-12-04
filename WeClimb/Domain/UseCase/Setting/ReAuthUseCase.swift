//
//  ReAuthUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 12/2/24.
//

import RxSwift
import AuthenticationServices

public protocol ReAuthUseCase {
    func execute() -> Observable<Result<Bool, ReAuthError>>
}

public enum ReAuthError: Error {
    case appleError
    case googleError
    case kakaoError
    case noLoginType
}

public struct ReAuthUseCaseImpl: ReAuthUseCase {
    private let loginRepository: LoginRepository
    
    public init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }
    
    public func execute() -> Observable<Result<Bool, ReAuthError>> {
        return Observable.create { observer in
            let snsAuthVM = SNSAuthVM()
            // 현재 로그인된 사용자 타입 확인
            let loginType = self.loginRepository.getLoginType()
            
            switch loginType {
            case .apple:
                // 애플 로그인 재인증
                snsAuthVM.appleLogin(delegate: snsAuthVM as! ASAuthorizationControllerDelegate,
                                     provider: snsAuthVM as! ASAuthorizationControllerPresentationContextProviding)
                observer.onNext(.success(true))
                observer.onCompleted()
                
            case .google:
                observer.onNext(.success(true))
                observer.onCompleted()
                
            case .kakao:
                observer.onNext(.success(true))
                observer.onCompleted()
                
            case .none:
                observer.onNext(.failure(ReAuthError.noLoginType))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
