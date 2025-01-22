//
//  SearchVM.swift
//  WeClimb
//
//  Created by 강유정 on 1/21/25.
//

import UIKit

import RxSwift
import RxCocoa

protocol SearchInput {
    var query: Observable<String> { get }
    var searchButtonTapped: Observable<Void> { get }
}

protocol SearchOutput {
    var items: Observable<[SearchResultItem]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<String> { get }
}

protocol SearchVM {
    func transform(input: SearchInput) -> SearchOutput
}

class SearchVMImpl: SearchVM {
    private let disposeBag = DisposeBag()
    
    private let fetchAllGymsInfoUseCase: FetchAllGymsInfoUseCase
    private let searchGymsUseCase: SearchGymsUseCase
    private let userSearchUseCase: UserSearchUseCase
    private let fetchImageURLUseCase: FetchImageURLUseCase
    
    private var allGyms: [SearchResultItem] = []
    private var allUsers: [SearchResultItem] = []
    
    init(fetchAllGymsInfoUseCase: FetchAllGymsInfoUseCase,
         searchGymsUseCase: SearchGymsUseCase,
         userSearchUseCase: UserSearchUseCase,
         fetchImageURLUseCase: FetchImageURLUseCase) {
        self.fetchAllGymsInfoUseCase = fetchAllGymsInfoUseCase
        self.searchGymsUseCase = searchGymsUseCase
        self.userSearchUseCase = userSearchUseCase
        self.fetchImageURLUseCase = fetchImageURLUseCase
    }
    
    struct Input: SearchInput {
        let query: Observable<String>
        let searchButtonTapped: Observable<Void>
    }
    
    struct Output: SearchOutput {
        let items: Observable<[SearchResultItem]>
        let isLoading: Observable<Bool>
        let error: Observable<String>
    }
    
    func transform(input: SearchInput) -> SearchOutput{
        let isLoadingSubject = BehaviorSubject<Bool>(value: false)
        let itemsSubject = BehaviorSubject<[SearchResultItem]>(value: [])
        let errorSubject = PublishSubject<String>()
        
        fetchInitialData()
            .subscribe(onNext: { [weak self] gyms in
                self?.allGyms = gyms
                self?.allUsers = []
                itemsSubject.onNext(self?.allGyms ?? [])
            })
            .disposed(by: disposeBag)
        
        let filteredItems = Observable.combineLatest(input.query, itemsSubject.asObservable())
            .flatMapLatest { query, items -> Observable<[SearchResultItem]> in
                if query.isEmpty {
                    return .just(items)
                } else {
                    let filtered = items.filter { $0.name.lowercased().contains(query.lowercased()) }
                    return .just(filtered)
                }
            }
     
        input.query
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] query -> Observable<[SearchResultItem]> in
                guard let self = self else {
                    return .empty()
                }
               
                if query.isEmpty {
                    return .just(self.allGyms + self.allUsers)
                } else {
                    isLoadingSubject.onNext(true)
                    
                    let filteredGyms = self.searchGyms(with: query)
                    let filteredUsers = self.searchUsers(with: query)
                    
                    return Observable.combineLatest(filteredGyms, filteredUsers) { gyms, users in
                        return gyms + users
                    }
                    .catch { error in
                        errorSubject.onNext("Error: \(error.localizedDescription)")
                        return .just([])
                    }
                    .do(onDispose: { isLoadingSubject.onNext(false) })
                }
            }
            .subscribe(onNext: { items in
                itemsSubject.onNext(items)
            })
            .disposed(by: disposeBag)
        
        return Output(
            items: filteredItems,
            isLoading: isLoadingSubject.asObservable(),
            error: errorSubject.asObservable()
        )
    }
    
    private func fetchInitialData() -> Observable<[SearchResultItem]> {
        return fetchAllGymsInfoUseCase.execute()
            .asObservable()
            .flatMap { [weak self] gyms -> Observable<[SearchResultItem]> in
                guard let self = self else {
                    return .just([])
                }

                let itemObservables = gyms.map { gym -> Observable<SearchResultItem> in
                    return self.fetchImageURLUseCase.execute(from: gym.profileImage ?? "")
                        .asObservable()
                        .do(onNext: { imageURLString in
                     
                        })
                        .map { imageURLString in
                            return SearchResultItem(type: .gym,
                                         name: gym.gymName,
                                         imageName: imageURLString ?? "",
                                         location: gym.address,
                                         height: nil)
                        }
                }

                return Observable.concat(itemObservables)
                    .toArray()
                    .asObservable()
            }
            .catch { _ in Observable.just([]) }
    }

    private func searchGyms(with query: String) -> Observable<[SearchResultItem]> {
         return searchGymsUseCase.execute(query: query)
             .asObservable()
             .flatMap { gyms -> Observable<[SearchResultItem]> in
                 let itemObservables = gyms.map { gym -> Observable<SearchResultItem> in
                     return self.fetchImageURLUseCase.execute(from: gym.profileImage ?? "")
                         .asObservable()
                         .map { imageURLString in
                             return SearchResultItem(type: .gym,
                                                      name: gym.gymName,
                                                      imageName: imageURLString ?? "",
                                                      location: gym.address,
                                                      height: nil)
                         }
                 }

                 return Observable.concat(itemObservables)
                     .toArray()
                     .asObservable()
             }
             .catch { error in
                 print("검색중 오류 발생: \(error)")
                 return Observable.just([])
             }
     }
   
    private func searchUsers(with query: String) -> Observable<[SearchResultItem]> {
        return userSearchUseCase.execute(with: query)
            .map { users in
                return users.map { user in
                    return SearchResultItem(type: .user,
                                name: user.userName ?? "",
                                imageName: user.profileImage ?? "",
                                location: nil,
                                height: user.height)
                }
            }
            .asObservable()
            .catch { _ in Observable.just([]) }
    }

}
