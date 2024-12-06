//
//  AppleLoginRepository.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/5/24.
//

import Foundation
import RxSwift

protocol AppleLoginRepository {
    func appleLogin() -> Single<LoginResult>
}
