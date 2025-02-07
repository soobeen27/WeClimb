//
//  FetchUserFeedInfoUseCase.swift
//  WeClimb
//
//  Created by 윤대성 on 2/5/25.
//

import Foundation

import RxSwift

protocol FetchUserFeedInfoUseCase {
    func execute(userUID: String) -> Single<[PostWithHold]>
}

class FetchUserFeedInfoUseCaseImpl: FetchUserFeedInfoUseCase {
    private let postAggregationRepository: PostAggregationRepository
    
    init(postAggregationRepository: PostAggregationRepository) {
        self.postAggregationRepository = postAggregationRepository
    }
    
    func execute(userUID: String) -> Single<[PostWithHold]> {
//        print("🚀 FetchUserFeedInfoUseCase 실행됨 - userUID: \(userUID)")
        return postAggregationRepository.getUserFeed(userUID: userUID)
                .do(onSuccess: { result in
//                    print("✅ FetchUserFeedInfoUseCase 결과: \(result.count)개 데이터 반환됨")
                })
    }
}
