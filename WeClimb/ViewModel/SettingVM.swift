//
//  SettingVM.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import FirebaseAuth
import RxSwift

class SettingVM {
    // MARK: - 파이어베이스 로그아웃 YJ
    func LogoutUser() -> Observable<Void> {
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
    
    // MARK: - 파이어베이스 회원탈퇴 YJ
    func deleteUser() -> Observable<Void> {
        return Observable.create { observer in
            FirebaseManager.shared.userDelete()
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
