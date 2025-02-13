//
//  UploadAssembly.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Swinject

final class UploadAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UploadPostDataSource.self) { _ in
            UploadPostDataSourceImpl()
        }
        
        container.register(UserReadDataSource.self) { _ in
            UserReadDataSourceImpl()
        }
        
        container.register(UploadPostRepository.self) { resolver in
            UploadPostRepositoryImpl(uploadPostDataSource: resolver.resolve(UploadPostDataSource.self)!)
        }
        
        container.register(UserReadRepository.self) { resolver in
            UserReadRepositoryImpl(userReadDataSource: resolver.resolve(UserReadDataSource.self)!)
        }

        container.register(UploadPostUseCase.self) { resolver in
            UploadPostUseCaseImpl(uploadPostRepository: resolver.resolve(UploadPostRepository.self)!
            )
        }

        container.register(MyUserInfoUseCase.self) { resolver in
            MyUserInfoUseCaseImpl(userReadRepository: resolver.resolve(UserReadRepository.self)!
            )
        }
        
        container.register(UploadVM.self) { resolver in
            UploadVMImpl()
        }
        
        container.register(UploadPostVM.self) { resolver in
            UploadPostVMImpl(uploadPostUseCase: resolver.resolve(UploadPostUseCase.self)!,
                             myUserInfoUseCase: resolver.resolve(MyUserInfoUseCase.self)!)
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
