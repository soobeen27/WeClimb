//
//  UserFeedTableCellVM.swift
//  WeClimb
//
//  Created by 윤대성 on 2/4/25.
//

import Foundation

import RxCocoa
import RxSwift

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
    private let useCase: FetchUserFeedInfoUseCase
    private let userId: String
    
    init(useCase: FetchUserFeedInfoUseCase, userId: String) {
        self.useCase = useCase
        self.userId = userId
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
        let dateTextRelay = BehaviorRelay<String>(value: "")
        let likeCountRelay = BehaviorRelay<String>(value: "0")
        let commentCountRelay = BehaviorRelay<String>(value: "0")
        let captionTextRelay = BehaviorRelay<String>(value: "")
        let badgeModelRelay = BehaviorRelay<FeedBageModel?>(value: nil)

        input.fetchDataTrigger
            .flatMapLatest { [useCase] in
                useCase.execute(userId: self.userId)
            }
            .subscribe(onNext: { postsWithHold in
                guard let firstPost = postsWithHold.first else { return }
                
                let post = firstPost.post
                dateTextRelay.accept(self.formatDate(post.creationDate))
                likeCountRelay.accept("\(post.like?.count ?? 0)")
                commentCountRelay.accept("\(post.commentCount ?? 0)")
                captionTextRelay.accept(post.caption ?? "")
                
                let badgeModel = FeedBageModel(
                    gymName: post.gym,
                    hold: firstPost.holds,
                    gymThmbnail: nil
                )
                badgeModelRelay.accept(badgeModel)
            })
            .disposed(by: disposeBag)
        
        return Output (
            dateText: dateTextRelay.asDriver(),
            likeCountText: likeCountRelay.asDriver(),
            commentCountText: commentCountRelay.asDriver(),
            captionText: captionTextRelay.asDriver(),
            badgeModel: badgeModelRelay.asDriver().compactMap { $0 }
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
