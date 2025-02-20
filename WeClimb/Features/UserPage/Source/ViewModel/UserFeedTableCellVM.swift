//
//  UserFeedTableCellVM.swift
//  WeClimb
//
//  Created by 윤대성 on 2/4/25.
//

import Foundation

import RxCocoa
import RxSwift

struct PostWithHold {
    let post: Post
    let holds: [String]
    let thumbnailURL: String?
}

protocol UserFeedTableCellInput {
    var fetchDataTrigger: ReplaySubject<Void> { get }
}

protocol UserFeedTableCellOutput {
    var dateText: Driver<String> { get }
    var likeCountText: Driver<String> { get }
    var commentCountText: Driver<String> { get }
    var captionText: Driver<String> { get }
    var badgeModel: Driver<FeedBageModel> { get }
}

protocol UserFeedTableCellVM {
    func transform(input: UserFeedTableCellInput) -> UserFeedTableCellOutput
}

class UserFeedTableCellVMImpl: UserFeedTableCellVM {
    private let disposeBag = DisposeBag()
   
    private let postWithHold: PostWithHold
    
    init(postWithHold: PostWithHold) {
        self.postWithHold = postWithHold
    }
    
    struct Input: UserFeedTableCellInput {
        var fetchDataTrigger: ReplaySubject<Void> = ReplaySubject.create(bufferSize: 1)
    }
    
    struct Output: UserFeedTableCellOutput {
        let dateText: Driver<String>
        let likeCountText: Driver<String>
        let commentCountText: Driver<String>
        let captionText: Driver<String>
        let badgeModel: Driver<FeedBageModel>
    }
    
    func transform(input: UserFeedTableCellInput) -> UserFeedTableCellOutput {
        let dateTextRelay = BehaviorRelay<String>(value: formatDate(postWithHold.post.creationDate))
        let likeCountRelay = BehaviorRelay<String>(value: "\(postWithHold.post.like?.count ?? 0)")
        let commentCountRelay = BehaviorRelay<String>(value: "\(postWithHold.post.commentCount ?? 0)")
        let captionTextRelay = BehaviorRelay<String>(value: postWithHold.post.caption ?? "")
        
        let badgeModel = FeedBageModel(
            gymName: postWithHold.post.gym,
            hold: postWithHold.holds,
            userFeedThmbnail: postWithHold.thumbnailURL
        )
        
        return Output(
            dateText: dateTextRelay.asDriver(),
            likeCountText: likeCountRelay.asDriver(),
            commentCountText: commentCountRelay.asDriver(),
            captionText: captionTextRelay.asDriver(),
            badgeModel: Driver.just(badgeModel)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
