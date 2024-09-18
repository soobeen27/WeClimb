//
//  SettingVM.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import RxSwift
import FirebaseAuth

// MARK: - 파이어베이스 로그아웃 YJ
class SettingVM {
    func performLogout() -> Observable<Void> {
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
