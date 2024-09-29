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
    
    // ViewModel의 Output
    let blackList = BehaviorRelay<[String]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    // 초기화
    init() {
        fetchBlackList()
    }
    
    // 차단 목록 가져오기
    func fetchBlackList() {
            isLoading.accept(true)
            FirebaseManager.shared.currentUserInfo { [weak self] result in
                guard let self else { return }
                self.isLoading.accept(false)
                
                switch result {
                case .success(let user):
                    self.blackList.accept(user.blackList ?? [])
                case .failure(let error):
                    print("차단 목록 가져오기 실패: \(error)")
                    self.blackList.accept([])
                }
            }
        }
    
    // 차단 추가
    func addToBlackList(userUID: String) {
        isLoading.accept(true)
        FirebaseManager.shared.addBlackList(blockedUser: userUID) { [weak self] success in
            guard let self else { return }
            if success {
                print("차단 성공")
                self.fetchBlackList()
            } else {
                print("차단 실패")
                self.isLoading.accept(false)
            }
        }
    }
    
    // 차단 해제
    func removeFromBlackList(userUID: String) {
        isLoading.accept(true)
        FirebaseManager.shared.removeBlackList(blockedUser: userUID) { [weak self] success in
            guard let self else { return }
            if success {
                print("차단 해제 성공")
                self.fetchBlackList()
            } else {
                print("차단 해제 실패")
                self.isLoading.accept(false)
            }
        }
    }
}
