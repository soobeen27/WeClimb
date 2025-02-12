//
//  PostCommentVM.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/4/25.
//

import FirebaseFirestore
import RxSwift
import RxCocoa

enum CommentAdditionalAction {
    case delete
    case report
    case block
}

struct CommentCellData {
    let commentUID: String
    let authorUID: String
    let profileImageURL: URL?
    let name: String
    let content: String
    let date: String
}

protocol PostCommentVM {
    func transform(input: PostCommentInput) -> PostCommentOutput
}

protocol PostCommentInput {
    var postItem: Observable<PostItem> { get }
    var sendButtonTap: Driver<String> { get }
    var cellLongPressed: PublishRelay<(commentUID: String, authorUID: String)> { get }
    var additonalActionTapped: PublishRelay<CommentAdditionalAction> { get }
}

protocol PostCommentOutput {
    var commentCellDatas: BehaviorRelay<[CommentCellData]> { get }
    var postOwnerName: Observable<String> { get }
    var isMyComment: Observable<Bool> { get }
}

class PostCommentVMImpl: PostCommentVM {
    private let addCommentUseCase: AddCommentUseCase
    private let fetchCommentUseCase: FetchCommentUseCase
    private let deleteCommentUseCase: DeleteCommentUseCase
    private let userInfoFromUIDUseCase: UserInfoFromUIDUseCase
    private let myUserInfoUseCase: MyUserInfoUseCase
    private let myUIDUseCase: MyUIDUseCase
    private let userReportUseCase: UserReportUseCase
    private let addBlackListUseCase: AddBlackListUseCase
    
    private let disposeBag = DisposeBag()
    
    private let commentsSubject = BehaviorSubject<[Comment]>(value: [])
    let cellDatasRelay = BehaviorRelay<[CommentCellData]>.init(value: [])
    private var postItem: PostItem?
    
    init(addCommentUseCase: AddCommentUseCase,
         fetchCommentUseCase: FetchCommentUseCase,
         deleteCommentUseCase: DeleteCommentUseCase,
         userInfoFromUIDUseCase: UserInfoFromUIDUseCase,
         myUserInfoUseCase: MyUserInfoUseCase,
         myUIDUseCase: MyUIDUseCase,
         userReportUseCase: UserReportUseCase,
         addBlackListUseCase: AddBlackListUseCase)
    {
        self.addCommentUseCase = addCommentUseCase
        self.fetchCommentUseCase = fetchCommentUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
        self.userInfoFromUIDUseCase = userInfoFromUIDUseCase
        self.myUserInfoUseCase = myUserInfoUseCase
        self.myUIDUseCase = myUIDUseCase
        self.userReportUseCase = userReportUseCase
        self.addBlackListUseCase = addBlackListUseCase
        commentsToCellData()
    }
    
    struct Input: PostCommentInput {
        let postItem: Observable<PostItem>
        let sendButtonTap: Driver<String>
        let cellLongPressed: PublishRelay<(commentUID: String, authorUID: String)>
        let additonalActionTapped: PublishRelay<CommentAdditionalAction>
    }
    
    struct Output: PostCommentOutput {
        let commentCellDatas: BehaviorRelay<[CommentCellData]>
        let postOwnerName: Observable<String>
        var isMyComment: Observable<Bool>
    }
    
    func transform(input: PostCommentInput) -> PostCommentOutput {
        var commentUID: String?
        var commentAuthor: String?
        
        input.postItem.subscribe(onNext: { [weak self] item in
            guard let self else { return }
            self.postItem = item
            self.fetchComments()
        })
        .disposed(by: disposeBag)
        
        input.sendButtonTap.drive(onNext: { [weak self] content in
            guard let self, let postItem = self.postItem else { return }
            self.addCommentUseCase.execute(postUID: postItem.postUID, content: content)
                .subscribe(onSuccess: {
                    self.fetchComments()
                }, onFailure: { error in
                    print("Send Comment Error: \(error)")
                })
                .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        let isMyComment = input.cellLongPressed.map { [weak self] uids in
            guard let myUID = try? self?.myUIDUseCase.execute() else { return false }
            commentUID = uids.commentUID
            commentAuthor = uids.authorUID
            return uids.authorUID == myUID
        }
        
        input.additonalActionTapped.subscribe(onNext: { [weak self] type in
            guard let self, let commentUID, let postUID =  self.postItem?.postUID else { return }
            switch type {
            case .delete:
                self.deleteCommentUseCase.execute(postUID: postUID, commentUID: commentUID)
                    .subscribe(onSuccess: {
                        self.fetchComments()
                    }, onFailure: { error in
                        print("delete comment error \(error)")
                    })
                    .disposed(by: self.disposeBag)
            case .block:
                guard let commentAuthor else { break }
                self.addBlackListUseCase.execute(blockedUser: commentAuthor)
                    .subscribe(onSuccess: { _ in
//                        추가 행동 추가 예정
                    }, onFailure: { error in
                        print("error blocking \(error)")
                    }).disposed(by: self.disposeBag)
            case .report:
                guard let commentAuthor else { break }
                guard let myUID = try? self.myUIDUseCase.execute() else { return }
                self.userReportUseCase.execute(content: "신고자: \(myUID)", userName: commentAuthor)
                    .subscribe(onCompleted: {
//                        추가 행동 추가 예정
                    }, onError: { error in
                        print("error reporting \(error)")
                    }).disposed(by: self.disposeBag)
            }
        }
        ).disposed(by: disposeBag)
        
        return Output(commentCellDatas: cellDatasRelay,
                      postOwnerName: getPostOwnerName(),
                      isMyComment: isMyComment
        )
    }
    
    private func fetchComments() {
        guard let postItem else { return }
        fetchCommentUseCase.execute(postUID: postItem.postUID, postOwner: postItem.authorUID)
            .subscribe(onSuccess: { [weak self] comments in
                guard let self else { return }
                self.commentsSubject.onNext(comments)
            }, onFailure: { error in
                print("Error fetch comments: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func commentsToCellData() {
        commentsSubject.subscribe(onNext: { [weak self] comments in
            guard let self else { return }
            let celldataObservables = comments.map { comment in
                self.userInfoFromUIDUseCase.execute(uid: comment.authorUID)
                    .map { userInfo in
                        var url: URL?
                        if let urlString = userInfo.profileImage {
                            url = URL(string: urlString)
                        }
                        return CommentCellData(commentUID: comment.commentUID,
                                               authorUID: comment.authorUID,
                                               profileImageURL: url,
                                               name: userInfo.userName ?? "",
                                               content: comment.content,
                                               date: comment.creationDate.toString())
                    }.asObservable()
            }
            Observable.combineLatest(celldataObservables)
                .subscribe(onNext: { cellDatas in
                    self.cellDatasRelay.accept(cellDatas)
                })
                .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
    }
    
    private func getPostOwnerName() -> Observable<String> {
        guard let postItem else { return Observable<String>.error(CommonError.selfNil) }
        return self.userInfoFromUIDUseCase.execute(uid: postItem.authorUID)
            .map { $0.userName ?? "" }
            .asObservable()
    }
}

