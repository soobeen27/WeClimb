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
    let userData = BehaviorRelay<[User]>(value: [])
    
    var filteredData = BehaviorRelay<[Gym]>(value: [])
    var userFilteredData = BehaviorRelay<[User]>(value: [])
    
    let searchText = BehaviorRelay<String>(value: "")
    let isSelectGym = BehaviorRelay<Bool>(value: true)
    private let disposeBag = DisposeBag()
    
    init() {
        fetchAllGyms()
        bindSearchText()
        
        isSelectGym
            .bind { [weak self ] _ in
                guard let text = self?.searchText.value else { return }
                self?.search(text: text)
            }.disposed(by: disposeBag)
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
    
    func fetchSearchUsers() {
        searchText
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }  // 빈 검색어는 무시
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                
                // Firestore에서 검색어에 맞는 유저만 가져옴
                FirebaseManager.shared.searchUsers(with: query) { users, error in
                    if let error = error {
                        print("Error fetching users: \(error)")
                        self.userFilteredData.accept([])  // 에러 시 빈 배열 전달
                    } else if let users = users {
                        self.userFilteredData.accept(users)  // 검색된 유저 데이터 업데이트
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func search(text: String) {
        if self.isSelectGym.value == true {
            if text.isEmpty {
                self.filteredData.accept(self.data.value) // Gym 검색
                self.userFilteredData.accept(self.userData.value) // User 검색
            } else {
                // Gym 검색 필터링
                let filteredGyms = self.data.value.filter { $0.gymName.contains(text) }
                self.filteredData.accept(filteredGyms)
            }
            
        } else {
            if text.isEmpty {
                self.userFilteredData.accept([])
                
            } else {
                FirebaseManager.shared.searchUsers(with: text) { users, error in
                    if let error = error {
                        print("Error fetching users: \(error)")
                        self.userFilteredData.accept([])
                    } else if let users = users {
                        self.userFilteredData.accept(users)
                    }
                }
            }
        }
    }
    
        func bindSearchText() {
                searchText
                    .subscribe(onNext: { [weak self] text in
                        self?.search(text: text)
                    })
                    .disposed(by: disposeBag)
            }
//        func bindSearchText() {
//            searchText
//                .subscribe(onNext: { [weak self] text in
//                    guard let self = self else { return }
//                    if self.isSelectGym.value == true {
//                        if text.isEmpty {
//                            self.filteredData.accept(self.data.value)  // Gym 검색
//                            self.userFilteredData.accept(self.userData.value)  // User 검색
//                        } else {
//                            let filterdGyms = self.data.value.filter { $0.gymName.contains(text) }
//                            self.filteredData.accept(filterdGyms)
//                        }
//                        
//                    } else {
//                        if text.isEmpty {
//                            self.userFilteredData.accept([])
//                            
//                        } else {
//                            FirebaseManager.shared.searchUsers(with: text) { users, error in
//                                if let error = error {
//                                    print("Error fetching users: \(error)")
//                                    self.userFilteredData.accept([])
//                                } else if let users = users {
//                                    self.userFilteredData.accept(users)
//                                }
//                            }
//                        }
//                    }
//                }
//                )                           }
}
