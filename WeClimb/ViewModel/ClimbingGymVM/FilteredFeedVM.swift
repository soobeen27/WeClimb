//
//  FilteredFeedVM.swift
//  WeClimb
//
//  Created by 머성이 on 11/22/24.
//

import RxCocoa
import RxSwift
import FirebaseFirestore

class FilteredFeedVM {
    
    let gymName: String
    let grade: String
    let hold: String?
    
    var posts = BehaviorRelay<[Post]>(value: [])
    var mediaItems = BehaviorRelay<[Media]>(value: [])
    private var lastSnapshot: QueryDocumentSnapshot?
    private let disposeBag = DisposeBag()
    
    init(gymName: String, grade: String, hold: String?) {
        self.gymName = gymName
        self.grade = grade
        self.hold = hold
        
        fetchFilteredPosts()
    }
    
    // 필터링된 Post 가져오기
    private func fetchFilteredPosts() {
        FirebaseManager.shared.getFilteredPost(
            gymName: gymName,
            grade: grade,
            hold: hold
        ) { [weak self] lastSnapshot in
            self?.lastSnapshot = lastSnapshot
        }
        .subscribe(onSuccess: { [weak self] posts in
            guard let self = self else { return }
            self.posts.accept(posts)
            self.fetchMediaForPosts(posts) // Post에서 Media 가져오기
        }, onFailure: { error in
            print("Error - Failed to fetch filtered posts: \(error)")
        })
        .disposed(by: disposeBag)
    }
    
    // 추가 Post 데이터 로드
    func fetchMoreFilteredPosts() {
        guard let lastSnapshot else { return } // 더 이상 로드할 데이터가 없을 경우 종료
        FirebaseManager.shared.getFilteredPost(
            lastSnapshot: lastSnapshot,
            gymName: gymName,
            grade: grade,
            hold: hold
        ) { [weak self] newSnapshot in
            self?.lastSnapshot = newSnapshot
        }
        .subscribe(onSuccess: { [weak self] newPosts in
            guard let self = self else { return }
            let updatedPosts = self.posts.value + newPosts
            self.posts.accept(updatedPosts)
            self.fetchMediaForPosts(newPosts)
        }, onFailure: { error in
            print("Error - Failed to fetch more posts: \(error)")
        })
        .disposed(by: disposeBag)
    }
    
    // Post에 연결된 Media 로드
    private func fetchMediaForPosts(_ posts: [Post]) {
        let mediaFetchTasks = posts.map { post in
            FirebaseManager.shared.fetchMedias(for: post)
        }
        
        Single.zip(mediaFetchTasks)
            .subscribe(onSuccess: { [weak self] mediaArrays in
                guard let self = self else { return }
                let newMediaItems = mediaArrays.flatMap { $0 }
                self.mediaItems.accept(self.mediaItems.value + newMediaItems)
            }, onFailure: { error in
                print("Error - Failed to fetch medias for posts: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
