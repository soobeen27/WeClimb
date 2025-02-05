//
//  UserFeedTableCellVM.swift
//  WeClimb
//
//  Created by 윤대성 on 2/4/25.
//

import RxCocoa
import RxSwift

protocol UserFeedTableCellInput {
    var fetchDataTrigger: PublishSubject<Void> { get }
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
    
    func transform(input: UserFeedTableCellInput) -> UserFeedTableCellOutput {
        let dateTextRelay = BehaviorRelay<String>(value: "")
        let likeCountRelay = BehaviorRelay<String>(value: "0")
        let commentCountRelay = BehaviorRelay<String>(value: "0")
        let captionTextRelay = BehaviorRelay<String>(value: "")
        let badgeModelRelay = BehaviorRelay<FeedBageModel?>(value: nil)
        
        input.fetchDataTrigger
//        // usecase들어갈자리
//            .flatMapLatest { [useCase] in
//                useCase.fetchFeedData() // Firebase에서 데이터 가져오는 로직
//            }
            .subscribe(onNext: { feedData in
                dateTextRelay.accept(feedData.dateString)
                likeCountRelay.accept("\(feedData.likeCount)")
                commentCountRelay.accept("\(feedData.commentCount)")
                captionTextRelay.accept(feedData.caption)
                badgeModelRelay.accept(feedData.badgeModel)
            })
            .disposed(by: disposeBag)
        
        return UserFeedTableCellOutputImpl(
            dateText: dateTextRelay.asDriver(),
            likeCountText: likeCountRelay.asDriver(),
            commentCountText: commentCountRelay.asDriver(),
            captionText: captionTextRelay.asDriver(),
            badgeModel: badgeModelRelay.asDriver().compactMap { $0 }
        )
    }
}

struct UserFeedTableCellOutputImpl: UserFeedTableCellOutput {
    let dateText: Driver<String>
    let likeCountText: Driver<String>
    let commentCountText: Driver<String>
    let captionText: Driver<String>
    let badgeModel: Driver<FeedBageModel>
}
