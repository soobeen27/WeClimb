//
//  UserPageVM.swift
//  WeClimb
//
//  Created by 머성이 on 9/18/24.
//

import RxCocoa
import RxSwift

class UserPageVM {
    private let disposeBag = DisposeBag()
    private let userSubject = BehaviorSubject<User?>(value: nil)
    
    // 유저 데이터를 관찰하는 Observable
    var userData: Observable<User?> {
        return userSubject.asObservable()
    }
    
    // 차단로직
    func blockUser(byUID uid: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.shared.addBlackList(blockedUser: uid) { success in
            if success {
                print("차단 성공")
                completion(true)
            } else {
                print("차단 실패")
                completion(false)
            }
        }
    }
}
