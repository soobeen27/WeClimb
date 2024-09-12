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
    
    let data = BehaviorRelay<[Gym]>(value: [])
    var filteredData = BehaviorRelay<[Gym]>(value: [])
    var userFilteredData = BehaviorSubject<[User]>(value: [])
    let searchText = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    init() {
        fetchAllGyms()
        bindSearchText()
//        fetchUserInfo()
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
                        let validGyms = gyms.compactMap { $0 } // nil 값 필터링
                        self?.data.accept(validGyms) // 테이블 뷰에 전달할 데이터
                        self?.filteredData.accept(validGyms) // 필터링 되지 않은 초기 데이터
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
    
//    func fetchUserInfo(name: String) {
//        FirebaseManager.shared.getUserInfoFrom(name: name) { [weak self] result in
//            switch result {
//            case .success(let user):
//                self?.userFilteredData.onNext([user])
//            case .failure(let error):
//                print("user info error")
//                self?.userFilteredData.onNext([])
//            }
//        }
//    }
    
    func bindSearchText() {
        searchText
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.isEmpty {
                    self.filteredData.accept(self.data.value) // 검색어가 없으면 전체 데이터 표시
                } else {
                    let filtered = self.data.value.filter { $0.gymName.contains(text) }
                    self.filteredData.accept(filtered) // 검색어로 필터링된 데이터 표시
                }
            })
            .disposed(by: disposeBag)
    }
}
