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
        return postAggregationRepository.getUserFeed(userUID: userUID)
    }
}
