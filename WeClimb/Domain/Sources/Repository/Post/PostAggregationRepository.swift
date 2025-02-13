//
//  PostAggregationRepository.swift
//  WeClimb
//
//  Created by 윤대성 on 2/5/25.
//

import Foundation

import RxSwift

struct PostWithHold {
    let post: Post
    let holds: [String]
}

protocol PostAggregationRepository {
    func getUserFeed(userUID: String) -> Single<[PostWithHold]>
}
