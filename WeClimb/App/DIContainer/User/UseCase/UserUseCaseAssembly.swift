//
//  UserUseCaseAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class UserUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MyUserInfoUseCase.self) { resolver in
            MyUserInfoUseCaseImpl(userReadRepository: resolver.resolve(UserReadRepository.self)!)
        }
        container.register(SNSAgreeUsecase.self) { resolver in
            SNSAgreeUsecaseImpl(userUpdateRepository: resolver.resolve(UserUpdateRepository.self)!)
        }
        
        container.register(UserInfoFromUIDUseCase.self) { resolver in
            UserInfoFromUIDUseCaseImpl(userReadRepository: resolver.resolve(UserReadRepository.self)!)
        container.register(NicknameDuplicationCheckUseCase.self) { resolver in
            NicknameDuplicationCheckUseCaseImpl(NicknameDuplicationCheckRepository: resolver.resolve(NicknameDuplicationCheckRepository.self)!)
        }
        container.register(NicknameRegisterUseCase.self) { resolver in
            NicknameRegisterUseCaseImpl(userUpdateRepository: resolver.resolve(UserUpdateRepository.self)!)
        }
        container.register(PersonalDetailUseCase.self) { resolver in
            PersonalDetailUseCaseImpl(userUpdateRepository: resolver.resolve(UserUpdateRepository.self)!)
        }
    }
}
