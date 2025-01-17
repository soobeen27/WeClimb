//
//  NicknameDuplicationCheckRepositoryImpl.swift
//  WeClimb
//
//  Created by 윤대성 on 1/9/25.
//

import Foundation

import RxSwift

final class NicknameDuplicationCheckRepositoryImpl: NicknameDuplicationCheckRepository {
    private let userReadDataSource: UserReadDataSource
    
    init(userReadDataSource: UserReadDataSource) {
        self.userReadDataSource = userReadDataSource
    }
    
    func checkUserNameDuplication(name: String) -> Single<User?> {
            return userReadDataSource.userInfoFromName(name: name)
                .map { $0 }
                .catchAndReturn(nil)
        }

}
