//
//  UserDataSourceAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class UserDataSourceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ImageDataSource.self) { _ in ImageDataSourceImpl() }
        container.register(UserBlockDataSource.self) { _ in UserBlockDataSourceImpl() }
        container.register(UserDeleteDataSource.self) {_ in UserDeleteDataSourceImpl()}
        container.register(UserReadDataSource.self) { _ in UserReadDataSourceImpl() }
        container.register(UserSearchDataSource.self) { _ in UserSearchDataSourceImpl() }
        container.register(UserUpdateDataSource.self) { _ in UserUpdateDataSourceImpl() }
        
    }
}
