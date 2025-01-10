//
//  FeedVM.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/7/25.
//

import Foundation

import FirebaseFirestore
import RxSwift
import RxCocoa

protocol FeedVM {
    var postItemRelay: BehaviorRelay<[PostItem]> {get}
}

struct PostItem: Hashable {
    let postUID: String
    let authorUID: String
    let creationDate: Date
    let caption: String?
    let like: [String]?
    let gym: String?
    let medias: [String]?
    let thumbnail: String?
    let commentCount: Int?
    
    init(postUID: String, authorUID: String, creationDate: Date, caption: String?, like: [String]?, gym: String?, medias: [DocumentReference]?, thumbnail: String?, commentCount: Int?) {
        self.postUID = postUID
        self.authorUID = authorUID
        self.creationDate = creationDate
        self.caption = caption
        self.like = like
        self.gym = gym
        self.medias = medias?.map { $0.path }
        self.thumbnail = thumbnail
        self.commentCount = commentCount
    }
}

class FeedVMImpl: FeedVM {
    let disposeBag = DisposeBag()
    let mainFeedUseCase: MainFeedUseCase
    let myUserInfo: MyUserInfoUseCase
    
    let postItemRelay = BehaviorRelay<[PostItem]>.init(value: [])
    
    init(mainFeedUseCase: MainFeedUseCase, myUserInfo: MyUserInfoUseCase) {
        self.mainFeedUseCase = mainFeedUseCase
        self.myUserInfo = myUserInfo
        fetchPost(type: .initial)
    }
    
    enum FetchPostType {
        case initial
        case more
    }
    
    func fetchPost(type: FetchPostType) {
        myUserInfo.execute()
            .flatMap { [weak self] user -> Single<[Post]> in
                guard let self else { return Single.error(UserError.noID) }
                return self.mainFeedUseCase.execute(user: user)
            }
            .subscribe(onSuccess: { [weak self] posts in
                guard let self else { return }
                let postItems = posts.map {
                    self.postToPostItem(post: $0)
                }
                switch type {
                case .initial:
                    self.acceptInitialPostItem(postItem: postItems)
                case .more:
                    self.acceptMorePostItem(postItem: postItems)
                }
            }, onFailure: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func postToPostItem(post: Post) -> PostItem {
        let postItem = PostItem(postUID: post.postUID,
                                authorUID: post.authorUID,
                                creationDate: post.creationDate,
                                caption: post.caption,
                                like: post.like,
                                gym: post.gym,
                                medias: post.medias,
                                thumbnail: post.thumbnail,
                                commentCount: post.commentCount)
        return postItem
    }
    
    private func acceptInitialPostItem(postItem: [PostItem]) {
        postItemRelay.accept(postItem)
    }
    
    private func acceptMorePostItem(postItem: [PostItem]) {
        let oldValue = postItemRelay.value
        let newValue = oldValue + postItem
        postItemRelay.accept(newValue)
    }
    
}
