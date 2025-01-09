//
//  MainFeedRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import Foundation

import RxSwift

final class MainFeedRepositoryImpl: MainFeedRepository {
    private let mainFeedDataSource: MainFeedDataSource
    
    init(mainFeedDataSource: MainFeedDataSource) {
        self.mainFeedDataSource = mainFeedDataSource
    }
    
    func getFeed(user: User?) -> Single<[Post]> {
        return mainFeedDataSource.getFeed(user: user)
    }
}
