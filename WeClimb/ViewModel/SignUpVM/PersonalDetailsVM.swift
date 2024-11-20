//
//  PersonalDetailsVM.swift
//  WeClimb
//
//  Created by 김솔비 on 9/24/24.
//

import Foundation

import RxCocoa
import RxSwift

class PersonalDetailsVM {
    
    let updateSuccess = PublishRelay<Bool>() // 업데이트 결과 전달용 Relay
    
    func updateUserDetails(data: [String: Any]) {
        FirebaseManager.shared.updateUserDetails(data: data) { success in
            self.updateSuccess.accept(success) // 결과 전달
        }
    }
}
