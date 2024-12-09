//
//  ReAuthRepository.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/5/24.
//

import Foundation

import RxSwift

protocol ReAuthRepository {
    func reAuthApple() -> Completable
    func reAuthGoogle(presenterProvider: @escaping PresenterProvider) -> Completable
    func reAuthKakao() -> Completable
}
