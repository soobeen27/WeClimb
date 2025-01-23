//
//  SearchAssembly.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Swinject

final class SearchAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GymDataSource.self) { _ in
            GymDataSourceImpl()
        }
        container.register(UserSearchDataSource.self) { _ in
            UserSearchDataSourceImpl()
        }
        container.register(FirebaseImageDataSource.self) { _ in
            FirebaseImageDataSourceImpl()
        }
        
        container.register(GymRepository.self) { resolver in
            GymRepositoryImpl(gymDataSource: resolver.resolve(GymDataSource.self)!)
        }
        
        container.register(UserSearchRepository.self) { resolver in
            UserSearchRepositoryImpl(userSearchDataSource: resolver.resolve(UserSearchDataSource.self)!
            )
        }
        
        container.register(FirebaseImageRepository.self) { resolver in
            FirebaseImageRepositoryImpl(firebaseImageDataSource: resolver.resolve(FirebaseImageDataSource.self)!
            )
        }
        
        container.register(FetchAllGymsInfoUseCase.self) { resolver in
            FetchAllGymsInfoUseCaseImpl(gymRepository: resolver.resolve(GymRepository.self)!
            )
        }
        
        container.register(SearchGymsUseCase.self) { resolver in
            SearchGymsUseCaseImpl(gymRepository: resolver.resolve(GymRepository.self)!
            )
        }
        
        container.register(UserSearchUseCase.self) { resolver in
            UserSearchUseCaseImpl(userSearchRepository: resolver.resolve(UserSearchRepository.self)!
            )
        }
        
        container.register(FetchImageURLUseCase.self) { resolver in
            FetchImageURLUseCaseImpl(firebaseimageRepository: resolver.resolve(FirebaseImageRepository.self)!
            )
        }
        
        container.register(SearchVM.self) { resolver in
            SearchVMImpl()
        }
        
        container.register(SearchResultVM.self) { resolver in
            SearchResultVMImpl(
                fetchAllGymsInfoUseCase: resolver.resolve(FetchAllGymsInfoUseCase.self)!,
                searchGymsUseCase: resolver.resolve(SearchGymsUseCase.self)!,
                userSearchUseCase: resolver.resolve(UserSearchUseCase.self)!,
                fetchImageURLUseCase: resolver.resolve(FetchImageURLUseCase.self)!)
        }
    }
}
