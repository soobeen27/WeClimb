//
//  PostAggregationRepository.swift
//  WeClimb
//
//  Created by 윤대성 on 2/5/25.
//

import Foundation

import RxSwift

protocol PostAggregationRepository {
    func getUserFeed(userUID: String) -> Single<[PostWithHold]>
}
