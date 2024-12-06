//
//  KakaoLoginRepository.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/5/24.
//

import Foundation
import RxSwift

protocol KakaoLoginRepository {
    func kakaoLogin() -> Single<LoginResult>
}
