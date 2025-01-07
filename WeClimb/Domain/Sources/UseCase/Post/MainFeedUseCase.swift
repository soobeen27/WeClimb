//
//  MainFeedUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/7/25.
//
import Foundation

import RxSwift

protocol MainFeedUseCase {
    func execute(user: User?) -> Single<[Post]>
}

struct MainFeedUseCaseImpl: MainFeedUseCase {
    private let mainFeedRepository: MainFeedRepository
    
    init(mainFeedRepository: MainFeedRepository) {
        self.mainFeedRepository = mainFeedRepository
    }
    
    func execute(user: User?) -> Single<[Post]> {
        return mainFeedRepository.getFeed(user: user)
    }
}
