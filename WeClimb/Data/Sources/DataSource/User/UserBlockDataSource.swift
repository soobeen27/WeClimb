//
//  UserBlockDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/28/24.
//

import Foundation
import RxSwift
import Firebase

protocol UserBlockDataSource {
    func addBlackList(blockedUser uid: String) -> Single<Void>
    func removeBlackList(blockedUser uid: String) -> Single<Void>
}

class UserBlockDataSourceImpl: UserBlockDataSource {
    private let db = Firestore.firestore()
    
    func addBlackList(blockedUser uid: String) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self,
                  let myUid = try? FirestoreHelper.userUID()
            else { return Disposables.create() }
            let userRef = db.collection("users").document(myUid)
            
            userRef.updateData(["blackList" : FieldValue.arrayUnion([uid])]) { error in
                if let error = error {
                    single(.failure(error))
                }
                single(.success(()))
            }
            return Disposables.create()
        }
    }
    
    func removeBlackList(blockedUser uid: String) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self,
                  let uid = try? FirestoreHelper.userUID()
            else { return Disposables.create() }
            let userRef = db.collection("users").document(uid)
            
            userRef.updateData(["blackList" : FieldValue.arrayRemove([uid])]) { error in
                if let error = error {
                    single(.failure(error))
                }
                single(.success(()))
            }
            return Disposables.create()
        }
    }
}
