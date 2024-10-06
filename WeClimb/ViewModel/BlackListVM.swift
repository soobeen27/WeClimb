//
//  BlackListVM.swift
//  WeClimb
//
//  Created by 머성이 on 9/26/24.
//

import Foundation

import RxCocoa
import RxSwift

class BlackListVM {
    private let disposeBag = DisposeBag()
    
    // 차단된 유저 정보와 UID 관리
    var blackListedUsers = BehaviorRelay<[User]>(value: [])
    var blackListedUIDs = BehaviorRelay<[String]>(value: [])
    
    // 차단된 사용자 목록 가져오기
    func fetchBlackList() {
        FirebaseManager.shared.currentUserInfo { result in
            switch result {
            case .success(let user):
                print("현재 유저 정보: \(user)") // 유저 정보가 제대로 오는지 확인
                guard let blackList = user.blackList else {
                    print("차단된 목록이 없습니다.")
                    return
                }
                print("차단된 유저 UID 목록: \(blackList)") // blackList가 nil이 아닌지 확인
                
                let userFetchGroup = DispatchGroup()
                var users: [User] = []
                var uids: [String] = []
                
                blackList.forEach { uid in
                    userFetchGroup.enter()
                    FirebaseManager.shared.getUserInfoFrom(uid: uid) { userResult in
                        switch userResult {
                        case .success(let blockedUser):
                            users.append(blockedUser)
                            uids.append(uid)
                        case .failure(let error):
                            print("차단된 유저 정보 가져오기 에러: \(error)")
                        }
                        userFetchGroup.leave()
                    }
                }
                
                userFetchGroup.notify(queue: .main) {
                    self.blackListedUsers.accept(users)
                    self.blackListedUIDs.accept(uids)
                }
            case .failure(let error):
                print("현재 유저 정보 가져오기 실패: \(error)")
            }
        }
    }
    
    // 차단 해제 기능
    func unblockUser(uid: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.shared.removeBlackList(blockedUser: uid) { success in
            if success {
                print("차단 해제 완료!")
            } else {
                print("차단 해제 실패")
            }
            completion(success)
        }
    }
}
