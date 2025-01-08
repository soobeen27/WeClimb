//
//  FeedVM.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/7/25.
//

import Foundation

import RxSwift

protocol FeedVM {
    
}

class FeedVMImpl: FeedVM {
    let disposeBag = DisposeBag()
    let mainFeedUseCase: MainFeedUseCase
    
    init(mainFeedUseCase: MainFeedUseCase) {
        self.mainFeedUseCase = mainFeedUseCase
    }
    
}
