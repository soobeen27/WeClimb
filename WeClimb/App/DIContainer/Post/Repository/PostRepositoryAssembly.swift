//
//  PostRepositoryAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import Swinject

final class PostRepositoryAssembly: Assembly {
    func assemble(container: Container) {
        //        container.register(PostRepository.self) { resolver in
        //            PostRepositoryImpl(postRepository: resolver.resolve())
        //        }
        container.register(UploadPostRepository.self) { resolver in
            UploadPostRepositoryImpl(uploadPostDataSource: resolver.resolve(UploadPostDataSource.self)!)
        }
        container.register(MainFeedRepository.self) { resolver in
            MainFeedRepositoryImpl(mainFeedDataSource: resolver.resolve(MainFeedDataSource.self)!)
        }
//        container.register(PostFilterRepository.self) { resolver in
//            PostFilterRepositoryImpl(postFilterDataSource: resolver.resolve(PostFilterDataSource.self)!
//            )
//        }
        container.register(PostRepository.self) { resolver in
            PostRepositoryImpl(postDataSource: resolver.resolve(PostDataSource.self)!)
        }
        
        container.register(FetchMediasRepository.self) { resolver in
            FetchMediasRepositoryImpl(fetchMediasDataSource: resolver.resolve(FetchMediasDataSource.self)!)
        }
        container.register(PostDeleteRepository.self) { resolver in
            PostDeleteRepositoryImpl(postDeleteDataSource: resolver.resolve(PostDeleteDataSource.self)!)
        }
        
        container.register(PostAggregationRepository.self) { resolver in
            PostAggregationRepositoryImpl(
                postRemoteDataSource: resolver.resolve(PostRemoteDataSource.self)!,
                mediaRemoteDataSource: resolver.resolve(MediaRemoteDataSource.self)!
            )
        }
        container.register(PostFilterRepository.self) { resolver in
            PostFilterRepositoryImpl(postFilterDataSource: resolver.resolve(PostFilterDataSource.self)!)
        }
        
    }
}
