//
//  FetchUserFeedInfoUseCase.swift
//  WeClimb
//
//  Created by 윤대성 on 2/5/25.
//

import Foundation

import RxSwift

protocol FetchUserFeedInfoUseCase {
    func execute(userId: String) -> Single<[PostWithHold]>
}

class FetchUserFeedInfoUseCaseImpl {
    private let repository: PostAggregationRepository
    
    init(repository: PostAggregationRepository) {
        self.repository = repository
    }
    
    func execute(userId: String) -> Single<[PostWithHold]> {
        return repository.getUserFeed(userId: userId)
    }
}
