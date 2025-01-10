//
//  FeedSubDataSourceAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class FeedSubDataSourceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CommentDataSource.self) { _ in
            CommentDataSourceImpl()
        }
        container.register(LikePostDataSource.self) { _ in
            LikePostDataSourceImpl()
        }
    }
}
