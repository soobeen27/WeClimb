//
//  MainFeedVM.swift
//  WeClimb
//
//  Created by 김솔비 on 8/29/24.
//

import Foundation

import RxSwift

class MainFeedVM {
    private let disposeBag = DisposeBag()
    
    let posts = PublishSubject<[(post: Post, media: [Media])]>() // 포스트 데이터 스트림
    
    // 피드 데이터 초기 로드
    func fetchInitialFeed() {
        FirebaseManager.shared.feedFirst { [weak self] fetchedPosts in
            guard let self, let fetchedPosts = fetchedPosts else { return }
            self.posts.onNext(fetchedPosts)
        }
    }
    
    // 추가 데이터 로드
    func fetchMoreFeed() {
        FirebaseManager.shared.feedLoading { [weak self] fetchedPosts in
            guard let self, let fetchedPosts = fetchedPosts else { return }
            self.posts.onNext(fetchedPosts)
        }
    }
}
