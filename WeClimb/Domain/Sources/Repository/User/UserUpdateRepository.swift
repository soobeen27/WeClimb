//
//  UserUpdateRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift
import Firebase

protocol UserUpdateRepository {
    func updateUser<T>(with data: T, for field: UserUpdate, userRef: DocumentReference) -> Completable
    func uploadProfileImageToStorage(imageURL: URL, userUID: String) -> Single<URL>
}
