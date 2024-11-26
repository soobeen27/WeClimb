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
                guard let blackList = user.blackList, let _ = user.blackList?.first else {
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
        FirebaseManager.shared.removeBlackList(blockedUser: uid) { [weak self] success in
            guard let self = self else { return }
            if success {
                // 차단 목록에서 유저 삭제
                var updatedUsers = self.blackListedUsers.value
                var updatedUIDs = self.blackListedUIDs.value
                
                if let index = updatedUIDs.firstIndex(of: uid) {
                    updatedUsers.remove(at: index)
                    updatedUIDs.remove(at: index)
                    
                    // Relay 업데이트
                    self.blackListedUsers.accept(updatedUsers)
                    self.blackListedUIDs.accept(updatedUIDs)
                }
            }
            completion(success)
        }
    }
}
