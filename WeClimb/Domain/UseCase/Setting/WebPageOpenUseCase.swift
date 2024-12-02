//
//  WebPageOpenUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 11/29/24.
//

import RxSwift
import SafariServices

public protocol WebPageOpenUseCase {
    func openWeb(urlString: String) -> Observable<Void>
}

public struct WebPageOpenUseCaseImpl: WebPageOpenUseCase {

    public func openWeb(urlString: String) -> Observable<Void> {
            // 웹 페이지 여는 로직
            return Observable.create { observer in
                // 웹 페이지 로딩 성공 처리
                observer.onNext(())
                observer.onCompleted()

                // 또는 실패 처리 예시
                // observer.onError(SomeError)

                return Disposables.create()
            }
        }
}
