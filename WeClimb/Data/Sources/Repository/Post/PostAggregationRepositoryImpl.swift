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
//                print("📌 PostAggregationRepository에서 받아온 Post 개수: \(posts.count)")
                
                let holdFetchObservables = posts.map { post in
                    self.mediaRemoteDataSource.fetchHolds(for: post.postUID)
                        .map { holds in
//                            print("🟢 postUID: \(post.postUID), 가져온 holds: \(holds)")
                            let postWithHold = PostWithHold(post: post, holds: holds)
//                            print("✅ 변환된 PostWithHold: \(postWithHold)")
                            return postWithHold
                        }
                }

//                print("🔄 holdFetchObservables 개수: \(holdFetchObservables.count)") // ✅ 개수 확인

                return Single.zip(holdFetchObservables)
                    .do(onSuccess: { result in
                        print("✅ Single.zip 실행됨: \(result.count)개의 PostWithHold 반환")
                    })
            }
    }
}
