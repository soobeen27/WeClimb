//
//  UserDeleteDataSource.swift
//  WeClimb
//
//  Created by 머성이 on 11/29/24.
//

import Foundation

import RxSwift
import Firebase
import FirebaseAuth
import FirebaseStorage

protocol UserDeleteDataSource {
    func userDelete() -> Completable
}

final class UserDeleteDataSourceImpl: UserDeleteDataSource {
    
    private let db = Firestore.firestore()
    
    func userDelete() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self, let user = Auth.auth().currentUser else {
                completable(.error(DeleteError.userNotAuthenticated))
                return Disposables.create()
            }
            
            user.delete { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    completable(.error(DeleteError.authenticationFailed))
                    return
                }
                print("authentication 성공적으로 계정 삭제")
                
                let userRef = self.db.collection("users").document(user.uid)
                userRef.delete { error in
                    if let error = error {
                        completable(.error(DeleteError.firestoreFailed))
                    } else {
                        print("firestore 성공적으로 계정 삭제")
                        completable(.completed)
                    }
                }
            }
            return Disposables.create()
        }
    }
}

enum DeleteError: Error {
    case authenticationFailed
    case firestoreFailed
    case userNotAuthenticated
    case unknownError(Error)
    
    var description: String {
        switch self {
        case .authenticationFailed:
            return "사용자 계정을 인증에서 삭제하지 못했습니다."
        case .firestoreFailed:
            return "사용자 데이터를 Firestore에서 삭제하지 못했습니다."
        case .userNotAuthenticated:
            return "현재 인증된 사용자가 없습니다."
        case .unknownError(let error):
            return "알 수 없는 오류가 발생했습니다: \(error.localizedDescription)"
        }
    }
}
