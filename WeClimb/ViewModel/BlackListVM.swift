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
    
    // 차단된 사용자 목록 (User 모델)
    var blackListedUsers = BehaviorRelay<[User]>(value: [])
    
    // 차단된 사용자 목록 가져오기
    func fetchBlackList() {
        // 현재 사용자 정보 가져오기
        FirebaseManager.shared.currentUserInfo { [weak self] result in
            switch result {
            case .success(let user):
                // blackList가 있으면 해당 UID로 사용자 정보 가져오기
                guard let blackListUIDs = user.blackList, !blackListUIDs.isEmpty else {
                    print("차단된 사용자가 없습니다.")
                    self?.blackListedUsers.accept([]) // 차단된 사용자가 없으면 빈 배열 전달
                    return
                }
                
                var blackListedUsers: [User] = []
                let group = DispatchGroup()
                
                // 차단된 UID에 해당하는 유저 정보를 가져오기
                for uid in blackListUIDs {
                    group.enter()
                    FirebaseManager.shared.getUserInfoFrom(uid: uid) { result in
                        switch result {
                        case .success(let blockedUser):
                            blackListedUsers.append(blockedUser)
                        case .failure(let error):
                            print("차단된 사용자 정보를 가져오는 중 오류: \(error)")
                        }
                        group.leave()
                    }
                }
                
                // 모든 사용자 정보를 다 가져온 후에 완료 핸들러 호출
                group.notify(queue: .main) {
                    self?.blackListedUsers.accept(blackListedUsers)  // 차단된 유저 목록 업데이트
                }
                
            case .failure(let error):
                print("현재 유저 정보를 가져오는 중 오류: \(error)")
                self?.blackListedUsers.accept([])  // 오류 발생 시 빈 배열 전달
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
