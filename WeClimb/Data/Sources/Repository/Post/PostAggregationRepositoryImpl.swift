//
//  PostAggregationRepositoryImpl.swift
//  WeClimb
//
//  Created by 윤대성 on 2/5/25.
//

import Foundation

import RxSwift

final class PostAggregationRepositoryImpl: PostAggregationRepository {
    private let postRemoteDataSource: PostRemoteDataSource
    private let mediaRemoteDataSource: MediaRemoteDataSource
    
    init(postRemoteDataSource: PostRemoteDataSource,
         mediaRemoteDataSource: MediaRemoteDataSource) {
        self.postRemoteDataSource = postRemoteDataSource
        self.mediaRemoteDataSource = mediaRemoteDataSource
    }
    
    func getUserFeed(userId: String) -> Single<[PostWithHold]> {
        return postRemoteDataSource.fetchUserPosts(userId: userId)
            .flatMap { posts in
                let holdFetchObservables = posts.map { post in
                    self.mediaRemoteDataSource.fetchHolds(for: post.postUID)
                        .map { holds in PostWithHold(post: post, holds: holds) }
                }
                return Single.zip(holdFetchObservables)
            }
    }
}
