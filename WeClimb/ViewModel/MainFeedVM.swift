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
    var posts = BehaviorRelay<[Post]>(value: [])
    var isLastCell = false
    var shouldFetch: Bool
    
    init(shouldFetch: Bool) {
        self.shouldFetch = shouldFetch
        if shouldFetch {
            fetchInitialFeed()
        }
    }
    
    // 피드 데이터 초기 로드
    func fetchInitialFeed() {
        FirebaseManager.shared.feedFirst { [weak self] fetchedPosts in
            guard let self, let fetchedPosts = fetchedPosts else { return }
            self.posts.accept(fetchedPosts)
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
        }
    }
    
    func fetchMyPosts() {
        FirebaseManager.shared.currentUserInfo { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                guard let posts = user.posts else { return }
                FirebaseManager.shared.postsFrom(postRefs: posts)
                    .subscribe(onNext: { data in
                        self.posts.accept(data)
                    }, onError: { error in
                        print("Error - while getting posts: \(error)")
                    })
                    .disposed(by: disposeBag)
            case .failure(let error):
                print("Error - while getting User Info")
            }
        }
    }
}
