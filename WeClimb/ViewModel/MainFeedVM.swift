//
//  MainFeedVM.swift
//  WeClimb
//
//  Created by 김솔비 on 8/29/24.
//

import Foundation

import RxCocoa
import RxSwift

class MainFeedVM {
    private let disposeBag = DisposeBag()
    
//    let posts = PublishSubject<[(post: Post, media: [Media])]>() // 포스트 데이터 스트림
    let posts = BehaviorRelay<[(post: Post, media: [Media])]>(value: [])
//    var posts: [(post: Post, media: [Media])] = []
    var isLastCell = false
    
    init() {
        fetchInitialFeed()
    }
    
    // 피드 데이터 초기 로드
    private func fetchInitialFeed() {
        FirebaseManager.shared.feedFirst { [weak self] fetchedPosts in
            guard let self, let fetchedPosts = fetchedPosts else { return }
//            print("******************************\(fetchedPosts)********************************************")
            self.posts.accept(fetchedPosts)
//            self.posts = fetchedPosts
        }
    }
    
    // 추가 데이터 로드
    func fetchMoreFeed() {
        FirebaseManager.shared.feedLoading { [weak self] fetchedPosts in
            guard let self, let fetchedPosts = fetchedPosts else { return }
            var loadedPosts = self.posts.value
            fetchedPosts.forEach {
                loadedPosts.append($0)
            }
            
            self.posts.accept(loadedPosts)
//            fetchedPosts.forEach {
//                self.posts.append($0)
//            }
        }
    }
}
