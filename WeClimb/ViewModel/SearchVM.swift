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
    let filteredData = BehaviorRelay<[SearchModel]>(value: [])
    let searchText = BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    
    init() {
        fetchAllGyms()
        bindSearchText()
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
                        return SearchModel(imageUrl: gym.profileImage, title: gym.gymName, address: gym.address)
                    }
                    self?.data.accept(searchModels) // 테이블 뷰에 전달할 데이터
                    self?.filteredData.accept(searchModels) // 필터링 되지 않은 초기 데이터
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
    
    private func bindSearchText() {
        searchText
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.isEmpty {
                    self.filteredData.accept(self.data.value) // 검색어가 없으면 전체 데이터 표시
                } else {
                    let filtered = self.data.value.filter { $0.title.contains(text) }
                    self.filteredData.accept(filtered) // 검색어로 필터링된 데이터 표시
                }
            })
            .disposed(by: disposeBag)
    }
}
