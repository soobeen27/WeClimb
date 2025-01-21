//
//  FeedAssembly.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Swinject

final class FeedAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FeedVM.self) { resolver in
            FeedVMImpl(mainFeedUseCase: resolver.resolve(MainFeedUseCase.self)!,
                       myUserInfo: resolver.resolve(MyUserInfoUseCase.self)!)
        }
        
        container.register(PostCollectionCellVM.self) { resolver in
            PostCollectionCellVMImpl(userInfoFromUIDUseCase: resolver.resolve(UserInfoFromUIDUseCase.self)!,
                                     myUIDUseCase: resolver.resolve(MyUIDUseCase.self)!,
                                     likePostUseCase: resolver.resolve(LikePostUseCase.self)!
            )
        }
        
        container.register(MediaCollectionCellVM.self) { resolver in
            MediaCollectionCellVMImpl()
        }
        
    }
}

/*
 이런식으로 활용할 수 있어요!
 container.register(MainPageDataSource.self) { _ in
     MainPageDataSourceImpl()
 }

 container.register(MainPageUsecase.self) { resolver in
     MainPageUsecaseImpl(mainPageDataSource: resolver.resolve(MainPageDataSource.self)!)
 }
 
 container.register(MainPageProtocol.self) { resolver in
     resolver.resolve(MainPageVM.self)! as MainPageProtocol
 }
 
 container.register(MainPageVM.self) { resolver in
     MainPageVM(usecase: resolver.resolve(MainPageUsecase.self)!)
 }
 
 container.register(MainPageBuilder.self) { resolver in
     MainPageBuilderImpl(container: self.container)
 }
 */
