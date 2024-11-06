//
//  LikeVM.swift
//  WeClimb
//
//  Created by 김솔비 on 10/18/24.
//

import RxSwift
import RxCocoa
import FirebaseCore
import FirebaseAuth

class LikeViewModel {
    
    private let disposedBag = DisposeBag()
    
    let postLikeList = BehaviorRelay<[String]>(value: [])
    let commentLikeList = BehaviorRelay<[String]>(value: [])
    let error = PublishSubject<Error>()
    
    func likePost(myUID: String, postUID: String, type: Like) {
        guard let user = Auth.auth().currentUser else { return }
        FirebaseManager.shared.like(myUID: myUID, targetUID: postUID, type: type)
            .subscribe { [weak self] result in
                switch result {
                case .success(let likeList):
                    self?.postLikeList.accept(likeList)
                case .failure(let error):
                    print("포스트 좋아요 중 오류", #file, #function, #line, error)
                }
            }
            .disposed(by: disposedBag)
    }
    
    func likeComment(myUID: String, CommentUID: String, type: Like) {
        guard let user = Auth.auth().currentUser else { return }
        FirebaseManager.shared.like(myUID: myUID, targetUID: CommentUID, type: type)
            .subscribe{ [weak self] result in
                switch result {
                case .success(let likeList):
                    self?.commentLikeList.accept(likeList)
                case .failure(let error):
                    print("댓글 좋아요 중 오류", #file, #function, #line, error)
                }
            }
            .disposed(by: disposedBag)
    }
}
