//
//  GoogleLoginRepository.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/5/24.
//

import Foundation
import RxSwift

protocol GoogleLoginRepository {
    func googleLogin(presentProvider: @escaping PresenterProvider) -> Single<LoginResult>
}
