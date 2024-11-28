//
//  UserDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/27/24.
//

import Foundation
import RxSwift
import Firebase
import FirebaseStorage

enum FuncError: Error {
    case wrongArgument
    case unknown
}

protocol UserDataSource {
//    func userInfo(name: String?, uid: String?) throws -> Single<User>
    func userInfoFromUID(uid: String) -> Single<User>
    func userInfoFromName(name: String) -> Single<User>
}

final class DefaultUserDataSource: UserDataSource {
    private let db = Firestore.firestore()
    private let disposeBag = DisposeBag()

    func userInfoFromUID(uid: String) -> Single<User> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            let userRef = db.collection("users").document(uid)
            userRef.getDocument(as: User.self) { result in
                switch result {
                case .success(let user):
                    single(.success(user))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func userInfoFromName(name: String) -> Single<User> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            let userRef = self.db.collection("users").whereField("userName", isEqualTo: name)
            userRef.getDocuments { snapshot, error in
                if let error = error {
                    single(.failure(error))
                }
                guard let snapshot else { return }
                snapshot.documents.forEach { document in
                    do {
                        let user = try document.data(as: User.self)
                        single(.success(user))
                    } catch {
                        single(.failure(error))
                    }
                }
            }
            return Disposables.create()
        }
    }
    //일단 폐기
//    func userInfo(name: String? = nil, uid: String? = nil) throws -> Single<User> {
//        if let name, let uid {
//            throw FuncError.wrongArgument
//        } else if let uid {
//            return userInfoFromUID(uid: uid)
//        } else if let name {
//            return userInfoFromName(name: name)
//        }
//        throw FuncError.unknown
//    }
    
}
