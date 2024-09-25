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
    
    // Firebase에서 유저 정보를 가져오는 함수
    func fetchUserInfo(userName: String) {
        FirebaseManager.shared.getUserInfoFrom(name: userName) { [weak self] result in
            switch result {
            case .success(let user):
                self?.userSubject.onNext(user)  // 성공적으로 가져온 유저 데이터를 방출
            case .failure(let error):
                print("Failed to fetch user info: \(error)")
                self?.userSubject.onError(error)  // 에러가 발생하면 에러 방출
            }
        }
    }
    
    // 사용자를 차단하는 함수
    func blockUser(withUID userUID: String) {
        FirebaseManager.shared.addBlackList(blockedUser: userUID) { success in
            if success {
                print("User successfully blocked.")
            } else {
                print("Failed to block user.")
            }
        }
    }
}
