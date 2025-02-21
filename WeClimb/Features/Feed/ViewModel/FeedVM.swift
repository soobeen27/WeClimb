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

protocol FeedInput {
    var postType: Observable<PostType?> { get }
    var fetchType: BehaviorRelay<PostFetchType?> { get }
    var additionalButtonTap: Observable<(postItem: PostItem, isMine: Bool)?> { get }
    var additionalButtonTapType: PublishRelay<FeedMenuSelection> { get }
}

protocol FeedOutput {
    var postItems: BehaviorRelay<[PostItem]> { get }
    var isMine: Observable<Bool> { get }
    var startIndex: BehaviorRelay<Int?> { get }
}

protocol FeedVM {
    func transform(input: FeedInput) -> FeedOutput
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

enum PostType {
    case feed
    case userPage(post: BehaviorSubject<[Post]>,
                  startIndex: BehaviorRelay<Int>)
    case gym(post: BehaviorSubject<[Post]>,
             filter: GymPostFilter,
             startIndex: BehaviorRelay<Int>)
    
}

enum PostFetchType {
    case initial
    case more
}

struct GymPostFilter {
    let gymName: String
    let grade: String?
    let hold: String?
    let height: [Int]?
    let armReach: [Int]?
    let lastSnapshot: QueryDocumentSnapshot?
}

class FeedVMImpl: FeedVM {
    private let disposeBag = DisposeBag()
    
    private let mainFeedUseCase: MainFeedUseCase
    private let myUserInfo: MyUserInfoUseCase
    private let userReportUseCase: UserReportUseCase
    private let addBlackListUseCase: AddBlackListUseCase
    private let postDeleteUseCase: PostDeleteUseCase
    private let myUIDUseCase: MyUIDUseCase
    private let userInfoFromUIDUseCase: UserInfoFromUIDUseCase
    private let postUseCase: PostUseCase
    
    
    private let postItemRelay: BehaviorRelay<[PostItem]> = .init(value: [])
    private let fetchType = BehaviorRelay<PostFetchType?>.init(value: nil)
    private let postType = BehaviorRelay<PostType?>.init(value: nil)
    let startIndex = BehaviorRelay<Int?>.init(value: nil)
    
    init(mainFeedUseCase: MainFeedUseCase,
         myUserInfo: MyUserInfoUseCase,
         userReportUseCase: UserReportUseCase,
         addBlackListUseCase: AddBlackListUseCase,
         postDeleteUseCase: PostDeleteUseCase,
         myUIDUseCase: MyUIDUseCase,
         userInfoFromUIDUseCase: UserInfoFromUIDUseCase,
         postUseCase: PostUseCase
    )
    {
        self.mainFeedUseCase = mainFeedUseCase
        self.myUserInfo = myUserInfo
        self.userReportUseCase = userReportUseCase
        self.addBlackListUseCase = addBlackListUseCase
        self.postDeleteUseCase = postDeleteUseCase
        self.myUIDUseCase = myUIDUseCase
        self.userInfoFromUIDUseCase = userInfoFromUIDUseCase
        self.postUseCase = postUseCase
        fetchPost()
    }
    
    struct Input: FeedInput {
        let postType: Observable<PostType?>
        let fetchType: BehaviorRelay<PostFetchType?>
        let additionalButtonTap: Observable<(postItem: PostItem, isMine: Bool)?>
        let additionalButtonTapType: PublishRelay<FeedMenuSelection>
    }
    
    struct Output: FeedOutput {
        let postItems: BehaviorRelay<[PostItem]>
        let isMine: Observable<Bool>
        let startIndex: BehaviorRelay<Int?>
    }
    
    func transform(input: FeedInput) -> FeedOutput {
        var currentPostItem: PostItem?

        input.fetchType.bind(to: fetchType).disposed(by: disposeBag)
        input.postType.bind(to: postType).disposed(by: disposeBag)
        
        let isMine = input.additionalButtonTap.compactMap { data in
            currentPostItem = data?.postItem
            return data?.isMine
        }
        
        input.additionalButtonTapType.subscribe(onNext: { [weak self] selection in
            guard let self, let currentPostItem else { return }
            switch selection {
            case .block:
                self.addBlackListUseCase.execute(blockedUser: currentPostItem.authorUID)
                    .subscribe(onSuccess: { _ in
                        //                        추가 행동 추가 예정
                    }, onFailure: { error in
                        print("error blocking \(error)")
                    }).disposed(by: self.disposeBag)
            case .delete:
                self.postDeleteUseCase.execute(uid: currentPostItem.postUID)
                    .subscribe(onSuccess: { _ in
//                        self.fetchPost(type: .initial)
                        self.fetchType.accept(.initial)
                    }, onFailure: { error in
                        print("error deleting \(error)")
                    }).disposed(by: self.disposeBag)
            case .report:
                guard let myUID = try? self.myUIDUseCase.execute() else { break }
                self.userReportUseCase.execute(content: "신고자: \(myUID)",
                                               userName: currentPostItem.authorUID)
                .subscribe(onCompleted: { [weak self] in
                    guard let self else { return }
                }, onError: { error in
                    print("error reporting \(error)")
                }).disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
        
        return Output(postItems: postItemRelay, isMine: isMine, startIndex: startIndex)
    }
    
    private func fetchPost() {
        Observable
            .combineLatest(fetchType, postType)
            .compactMap { fetchType, postType -> (PostFetchType, PostType)? in
                guard let fetchType, let postType else { return nil }
                return (fetchType, postType)
            }
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] fetch, post in
                guard let self else { return }
                switch post {
                case .feed:
                    self.feedFetchPost()
                case .gym(let posts, let filter, let startIndex):
                    print("")
                case .userPage(let posts, let startIndex):
                    posts.map { [weak self] posts in
                        posts.compactMap { self?.postToPostItem(post: $0 ) }
                    }
                    .bind(to: self.postItemRelay)
                    .disposed(by: self.disposeBag)
                    
                    self.startIndex.accept(startIndex.value)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func feedFetchPost() {
        myUserInfo.execute()
            .flatMap { [weak self] user -> Single<[Post]> in
                guard let self, let fetchType = self.fetchType.value else { return Single.error(UserError.noID) }
                let isInitial = fetchType == .initial
                return self.mainFeedUseCase.execute(user: user, isInitial: isInitial)
            }
            .subscribe(onSuccess: { [weak self] posts in
                guard let self, let fetchType = self.fetchType.value else { return }
                let postItems = posts.map {
                    return self.postToPostItem(post: $0)
                }
                switch fetchType {
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
