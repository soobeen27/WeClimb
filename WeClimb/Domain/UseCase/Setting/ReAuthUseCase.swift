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

//public struct ReAuthUseCaseImpl: ReAuthUseCase {
//    private let snsAuthVM = SNSAuthVM()
//
//    public func execute() -> Observable<Bool> {
//        return Observable.create { observer in
//            self.snsAuthVM.appleLogin(delegate: self.snsAuthVM as! ASAuthorizationControllerDelegate, provider: self.snsAuthVM as! ASAuthorizationControllerPresentationContextProviding)
//            observer.onNext(true)
//            observer.onCompleted()
//            return Disposables.create()
//        }
//    }
//}
//public struct ReAuthUseCaseImpl: ReAuthUseCase {
//    private let snsAuthVM = SNSAuthVM()
//    
//    public func execute() -> Observable<Bool> {
//        return Observable.create { observer in
//            let loginType = snsAuthVM.checkLoginType()  // 현재 로그인 타입 확인
//            
//            switch loginType {
//            case .apple:
//                snsAuthVM.appleLogin(delegate: snsAuthVM as! ASAuthorizationControllerDelegate,
//                                      provider: snsAuthVM as! ASAuthorizationControllerPresentationContextProviding)
//                observer.onNext(true)  // 성공적으로 실행된 것으로 처리, 실제로 인증이 완료된 후 success 처리
//                observer.onCompleted()
//                
//            case .google:
//                snsAuthVM.googleLogin(presenter: UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()) { [weak self] credential in
//                    self?.snsAuthVM.reAuthenticate(with: credential) { error in
//                        if let error = error {
//                            observer.onNext(false)
//                            observer.onCompleted()
//                            return
//                        }
//                        observer.onNext(true)
//                        observer.onCompleted()
//                    }
//                }
//                
//            case .kakao:
//                snsAuthVM.kakaoLogin { [weak self] credential in
//                    self?.snsAuthVM.reAuthenticate(with: credential) { error in
//                        if let error = error {
//                            observer.onNext(false)
//                            observer.onCompleted()
//                            return
//                        }
//                        observer.onNext(true)
//                        observer.onCompleted()
//                    }
//                }
//                
//            case .none:
//                observer.onNext(false)  // 로그인 타입이 없는 경우 실패 처리
//                observer.onCompleted()
//            }
//            
//            return Disposables.create()
//        }
//    }
//}
//
