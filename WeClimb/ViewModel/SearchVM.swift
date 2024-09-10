//
//  SearchVM.swift
//  WeClimb
//
//  Created by 강유정 on 8/27/24.
//

import UIKit

import RxSwift
import RxCocoa

class SearchViewModel {
    
    let data = BehaviorRelay<[SearchModel]>(value: [])
    let disposeBag = DisposeBag()
    
    init() {
        
        fetchAllGyms()
    }
    
    func fetchAllGyms() {
        FirebaseManager.shared.allGymName { [weak self] gymNames in
            // 이름 목록을 기반으로 각각의 암장 정보 가져오기
            Observable.from(gymNames) // gymNames 배열을 Observable 스트림으로 변환
                .flatMap { name -> Observable<Gym?> in
                    return self?.gymInfoObservable(from: name) ?? Observable.just(nil)
                }
                .toArray() // 배열로 변환
                .subscribe(onSuccess: { gyms in
                    let searchModels = gyms.compactMap { gym -> SearchModel? in
                        guard let gym = gym else { return nil }
                        return SearchModel(image: UIImage(named: "defaultImage"), title: gym.gymName, address: gym.address)
                    }
                    self?.data.accept(searchModels) // 테이블 뷰에 전달할 데이터
//                    print("테이블 뷰에 전달할 데이터: \(searchModels)")
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
        }
    }

    func gymInfoObservable(from name: String) -> Observable<Gym?> {
        return Observable.create { observer in
            FirebaseManager.shared.gymInfo(from: name) { gym in
                observer.onNext(gym)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
