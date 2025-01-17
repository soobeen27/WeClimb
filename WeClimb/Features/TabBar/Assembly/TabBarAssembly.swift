////
////  TabBarAssembly.swift
////  WeClimb
////
////  Created by 윤대성 on 1/7/25.
////
//
import Swinject

final class TabBarAssembly: Assembly {

    func assemble(container: Container) {
        
        // 개별 Builder 등록
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
        
//         TabBarBuilder 등록
        container.register(TabBarBuilder.self) { resolver in
            TabBarBuilderImpl(
                feedBuilder: resolver.resolve(FeedBuilder.self)!,
                searchBuilder: resolver.resolve(SearchBuilder.self)!,
                uploadBuilder: resolver.resolve(UploadBuilder.self)!,
                notificationBuilder: resolver.resolve(NotificationBuilder.self)!,
                userPageBuilder: resolver.resolve(UserPageBuilder.self)!
            )
        }
        
        // TabBarCoordinator 등록
        container.register(TabBarCoordinator.self) { resolver in
            let tabBarVC = TabBarVC()
            let tabBarBuilder = resolver.resolve(TabBarBuilder.self)!
            return TabBarCoordinator(
                tabBarController: tabBarVC,
                builder: tabBarBuilder
            )
        }
        
        // FeedVM 등록
        container.register(FeedVM.self) { resolver in
            let mainFeedUseCase = resolver.resolve(MainFeedUseCase.self)!
            let myUserInfoUseCase = resolver.resolve(MyUserInfoUseCase.self)!
            return FeedVMImpl(mainFeedUseCase: mainFeedUseCase, myUserInfo: myUserInfoUseCase)
        }
    }
}
