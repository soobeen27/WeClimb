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
    public let usecase: LoginUseCase
    
    init(usecase: LoginUseCase) {
        self.usecase = usecase
    }
    
    struct Input {
        let loginType: Observable<LoginType>
        let loginButtonTapped: Observable<Void>
        let presentProvider: PresenterProvider
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
            .flatMapLatest { [weak self] loginType -> Observable<Result<Void, Error>> in
                guard let self else { return .empty() }
                
                isLoadingSubject.onNext(true)
                
                let presentProvider = loginType == .google ? input.presentProvider : nil
                
                return self.usecase.execute(
                    loginType: loginType,
                    presentProvider: presentProvider
                )
                .map { _ in Result<Void, Error>.success(()) }
                .asObservable()
                .catch { .just(Result.failure($0)) }
                .do(onDispose: { isLoadingSubject.onNext(false) })
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
