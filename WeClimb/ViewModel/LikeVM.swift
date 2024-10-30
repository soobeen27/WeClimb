//
//  LikeVM.swift
//  WeClimb
//
//  Created by 김솔비 on 10/18/24.
//

import RxSwift
import RxCocoa
import FirebaseCore

class LikeViewModel {
    
    private let disposedBag = DisposeBag()
    
    let likeList = BehaviorRelay<[String]>(value: [])
    let error = PublishSubject<Error>()
    
    func likePost(myUID: String, postUID: String, type: Like) {
        if likeList.value.contains([myUID]) {
            FirebaseManager.shared.likeCancel(from: postUID, type: type)
                .subscribe(onNext: { [weak self] likeList in
                    print("Like 전달 성공")
                    self?.likeList.accept(likeList)
                }, onError: { [weak self] error in
                    print("Like 전달 실패")
                    self?.error.onNext(error)
                })
                .disposed(by: disposedBag)
        } else {
            FirebaseManager.shared.like(from: postUID, type: type)
                .subscribe(onNext: { [weak self] likeList in
                    print("Like 전달 성공")
                    self?.likeList.accept(likeList)
                }, onError: { [weak self] error in
                    print("Like 전달 실패")
                    self?.error.onNext(error)
                })
                .disposed(by: disposedBag)
        }
        
    }

}
