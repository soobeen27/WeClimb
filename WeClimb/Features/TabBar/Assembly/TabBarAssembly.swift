//
//  TabBarAssembly.swift
//  WeClimb
//
//  Created by 윤대성 on 1/7/25.
//

import Swinject

final class TabBarAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(FeedBuilder.self) { _ in
            FeedBuilderImpl()
        }
        container.register(SearchBuilder.self) { _ in
            SearchBuilderImpl()
        }
        container.register(UploadBuilder.self) { _ in
            UploadBuilderImpl()
        }
        container.register(NotificationBuilder.self) { _ in
            NotificationBuilderImpl()
        }
        container.register(UserPageBuilder.self) { _ in
            UserPageBuilderImpl()
        }
        
        container.register(TabBarCoordinator.self) { resolver in
            let tabBarVC = TabBarVC()
            return TabBarCoordinator(
                tabBarController: tabBarVC,
                feedBuilder: resolver.resolve(FeedBuilder.self)!,
                searchBuilder: resolver.resolve(SearchBuilder.self)!,
                uploadBuilder: resolver.resolve(UploadBuilder.self)!,
                notificationBuilder: resolver.resolve(NotificationBuilder.self)!,
                userPageBuilder: resolver.resolve(UserPageBuilder.self)!
            )
        }
        
        container.register(FeedVM.self) { resolver in
            let mainFeedUseCase = resolver.resolve(MainFeedUseCase.self)!
            return FeedVMImpl(mainFeedUseCase: mainFeedUseCase)
        }
    }
}
