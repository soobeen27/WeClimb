//
//  MyUserInfo.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/8/25.
//
import RxSwift

protocol MyUserInfoUseCase {
    func execute() -> Single<User?>
}

struct MyUserInfoUseCaseImpl: MyUserInfoUseCase {
    private let userReadRepository: UserReadRepository
    
    init(userReadRepository: UserReadRepository) {
        self.userReadRepository = userReadRepository
    }
    
    func execute() -> Single<User?> {
        userReadRepository.getMyUserInfo()
    }
}
