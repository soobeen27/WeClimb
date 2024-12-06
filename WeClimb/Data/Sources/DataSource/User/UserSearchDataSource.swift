//
//  UserSearchDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/6/24.
//

import Foundation

import Firebase
import RxSwift

protocol UserSearchDataSource {
    func searchUsers(with searchText: String) -> Single<[User]>
}

class UserSearchDataSourceImpl: UserSearchDataSource {
    private let db = Firestore.firestore()
    
    func searchUsers(with searchText: String) -> Single<[User]> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CommonError.selfNil))
                return Disposables.create()
            }
            self.db.collection("users")
                .whereField("userName", isGreaterThanOrEqualTo: searchText)
                .whereField("userName", isLessThanOrEqualTo: searchText + "\u{f8ff}")
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    guard let querySnapshot = querySnapshot else {
                        single(.success([]))
                        return
                    }
                    let users: [User] = querySnapshot.documents.compactMap { document in
                        do {
                            return try document.data(as: User.self)
                        } catch {
                            print("Error decoding user: \(error.localizedDescription)")
                            return nil
                        }
                    }
                    single(.success(users))
                }
            return Disposables.create()
        }
    }
}
