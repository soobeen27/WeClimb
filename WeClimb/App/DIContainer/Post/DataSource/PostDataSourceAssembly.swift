//
//  PostDataSourceAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class PostDataSourceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PostDataSource.self) { _ in
            PostDataSourceImpl()
        }
        container.register(MainFeedDataSource.self) { _ in
            MainFeedDataSourceImpl()
        }
        container.register(PostFilterDataSource.self) { _ in
            PostFilterDataSourceImpl()
        }
    }
}
