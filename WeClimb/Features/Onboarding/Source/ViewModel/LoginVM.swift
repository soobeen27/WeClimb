//
//  LoginVM.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

import RxCocoa
import RxSwift

protocol LoginVM {
    func transform(input: LoginImpl.Input) -> LoginImpl.Output
}

class LoginImpl: LoginVM {
    private let disposeBag = DisposeBag()
    public let usecase: LoginUsecase
    
    init(usecase: LoginUsecase) {
        self.usecase = usecase
    }
    
    struct Input {
        let loginType: Observable<LoginType>
        let loginButtonTapped: Observable<Void>
    }
    
    struct Output {
        let loginResult: Observable<Result<Void, Error>>
        let isLoading: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let isLoadingSubject = BehaviorSubject<Bool>(value: false)
        let loginResultSubject = PublishSubject<Result<Void, Error>>()
        
        input.loginButtonTapped
            .withLatestFrom(input.loginType)
            .flatMapLatest { [weak self] loginType -> Observable<Result<Void,Error>> in
                guard let self else { return .empty() }
                
                isLoadingSubject.onNext(true)
                
                /// Google은 presentProvider가 필요하지만, 현재 상황에서 VM은 presentProvider를 알 수 없으므로
                /// Apple, Kakao만 처리하고 Google은 별도로 LoginVC에서 처리 하고있음
                switch loginType {
                case .apple, .kakao:
                    return self.usecase.execute(loginType: loginType, presentProvider: nil)
                        .map { _ in Result<Void, Error>.success(()) }
                        .asObservable()
                        .catch { .just(Result.failure($0))}
                        .do(onDispose: { isLoadingSubject.onNext(false)})
                case .google:
                    return Observable.empty()
                default :
                    return .error(AppError.unknown)
                }
            }
            .subscribe(onNext: { result in
                loginResultSubject.onNext(result)
            })
            .disposed(by: disposeBag)
        
        return Output(
            loginResult: loginResultSubject.asObservable(),
            isLoading: isLoadingSubject.asObservable()
        )
    }
}
