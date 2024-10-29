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
    
    func likePost(uid: String, type: Like) {
        FirebaseManager.shared.like(from: uid, type: type)
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
