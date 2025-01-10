//
//  NicknameDuplicationCheckRepository.swift
//  WeClimb
//
//  Created by 윤대성 on 1/9/25.
//

import Foundation

import RxSwift

protocol NicknameDuplicationCheckRepository {
    func checkUserNameDuplication(name: String) -> Single<User?>
}
