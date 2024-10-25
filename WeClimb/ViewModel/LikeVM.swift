//
//  LikeVM.swift
//  WeClimb
//
//  Created by 김솔비 on 10/18/24.
//

import RxSwift

class LikeViewModel {
    
    private let disposedBag = DisposeBag()
    
    let likeList = PublishSubject<[String]>()
    let error = PublishSubject<Error>()
    
    func likePost(uid: String, type: Like) {
        FirebaseManager.shared.like(from: uid, type: type)
            .subscribe(onNext: { [weak self] likeList in
                self?.likeList.onNext(likeList)
            }, onError: { [weak self] error in
                self?.error.onNext(error)
            })
            .disposed(by: disposedBag)
    }
}
