//
//  UserRepositoryAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//
import Swinject

final class UserRepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ImageDataRepository.self) { resolver in
            ImageDataRepositoryImpl(imageDataSource: resolver.resolve(ImageDataSource.self)!)
        }
        container.register(UserBlockRepository.self) { resolver in
            UserBlockRepositoryImpl(userBlockDataSource: resolver.resolve(UserBlockDataSource.self)!)
        }
        container.register(UserDeleteRepository.self) { resolver in
            UserDeleteRepositoryImpl(userDeleteDataSource: resolver.resolve(UserDeleteDataSource.self)!)
        }
        container.register(UserReadRepository.self) { resolver in
            UserReadRepositoryImpl(userReadDataSource: resolver.resolve(UserReadDataSource.self)!)
        }
        container.register(UserUpdateRepository.self) { resolver in
            UserUpdateRepositoryImpl(userUpdateDataSource: resolver.resolve(UserUpdateDataSource.self)!)
        }
        container.register(NicknameDuplicationCheckRepository.self) { resolver in
            NicknameDuplicationCheckRepositoryImpl(userReadDataSource: resolver.resolve(UserReadDataSource.self)!)
        }
    }
}
