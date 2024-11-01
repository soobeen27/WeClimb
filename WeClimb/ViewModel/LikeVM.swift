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
    
    let likeList = BehaviorRelay<[String]>(value: [])
    let error = PublishSubject<Error>()
    
    func likePost(myUID: String, postUID: String, type: Like) {
//        if likeList.value.contains([myUID]) {
//            FirebaseManager.shared.likeCancel(from: postUID, type: type)
//                .subscribe(onNext: { [weak self] likeList in
//                    print("Like 전달 성공")
//                    self?.likeList.accept(likeList)
//                }, onError: { [weak self] error in
//                    print("Like 전달 실패")
//                    self?.error.onNext(error)
//                })
//                .disposed(by: disposedBag)
//        } else {
//            FirebaseManager.shared.like(from: postUID, type: type)
//                .subscribe(onNext: { [weak self] likeList in
//                    print("Like 전달 성공")
//                    self?.likeList.accept(likeList)
//                }, onError: { [weak self] error in
//                    print("Like 전달 실패")
//                    self?.error.onNext(error)
//                })
//                .disposed(by: disposedBag)
//        }/
        guard let user = Auth.auth().currentUser else { return }
        FirebaseManager.shared.like(myUID: myUID, targetUID: postUID, type: type)
            .subscribe { [weak self] result in
                switch result {
                case .success(let likeList):
                    self?.likeList.accept(likeList)
                case .failure(let error):
                    print("포스트 좋아요중 오류", #file, #function, #line, error)
                }
            }
            .disposed(by: disposedBag)
    }

}
