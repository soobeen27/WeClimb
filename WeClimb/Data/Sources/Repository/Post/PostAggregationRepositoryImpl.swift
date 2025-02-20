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
    
    func getUserFeed(userUID: String) -> Single<[PostWithHold]> {
        return postRemoteDataSource.fetchUserPosts(userUID: userUID)
            .flatMap { posts in
                let holdFetchObservables = posts.map { post in
                    Single.zip(
                        self.mediaRemoteDataSource.fetchHolds(for: post.postUID),
                        self.mediaRemoteDataSource.fetchThumbnail(for: post.postUID) // 🔹 썸네일 가져오기
                    ).map { holds, thumbnail in
                        let postWithHold = PostWithHold(post: post, holds: holds, thumbnailURL: thumbnail)
                        return postWithHold
                    }
                }

                return Single.zip(holdFetchObservables)
                    .do(onSuccess: { result in
                        print("✅ Single.zip 실행됨: \(result.count)개의 PostWithHold 반환")
                    })
            }
    }
}
