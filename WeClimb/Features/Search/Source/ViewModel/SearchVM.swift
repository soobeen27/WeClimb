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
    var items: Observable<[Item]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<String> { get }
}

protocol SearchVM {
    func transform(input: SearchInput) -> SearchOutput
}

class SearchVMImpl: SearchVM {
    private let disposeBag = DisposeBag()
    
    private let fetchAllGymsInfoUseCase: FetchAllGymsInfoUseCase
    private let fetchGymInfoUseCase: FetchGymInfoUseCase
    private let userSearchUseCase: UserSearchUseCase
    private let fetchImageURLUseCase: FetchImageURLUseCase
    
    private var allGyms: [Item] = []
    private var allUsers: [Item] = []
    
    init(fetchAllGymsInfoUseCase: FetchAllGymsInfoUseCase,
         fetchGymInfoUseCase: FetchGymInfoUseCase,
         userSearchUseCase: UserSearchUseCase,
         fetchImageURLUseCase: FetchImageURLUseCase) {
        self.fetchAllGymsInfoUseCase = fetchAllGymsInfoUseCase
        self.fetchGymInfoUseCase = fetchGymInfoUseCase
        self.userSearchUseCase = userSearchUseCase
        self.fetchImageURLUseCase = fetchImageURLUseCase
    }
    
    struct Input: SearchInput {
        let query: Observable<String>
        let searchButtonTapped: Observable<Void>
    }
    
    struct Output: SearchOutput {
        let items: Observable<[Item]>
        let isLoading: Observable<Bool>
        let error: Observable<String>
    }
    
    func transform(input: SearchInput) -> SearchOutput{
        let isLoadingSubject = BehaviorSubject<Bool>(value: false)
        let itemsSubject = BehaviorSubject<[Item]>(value: [])
        let errorSubject = PublishSubject<String>()
        
        fetchInitialData()
            .subscribe(onNext: { [weak self] gyms in
                self?.allGyms = gyms
                self?.allUsers = []
                itemsSubject.onNext(self?.allGyms ?? [])
            })
            .disposed(by: disposeBag)
        
        let filteredItems = Observable.combineLatest(input.query, itemsSubject.asObservable())
            .flatMapLatest { query, items -> Observable<[Item]> in
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
            .flatMapLatest { [weak self] query -> Observable<[Item]> in
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
    
    private func fetchInitialData() -> Observable<[Item]> {
        return fetchAllGymsInfoUseCase.execute()
            .asObservable()
            .flatMap { [weak self] gyms -> Observable<[Item]> in
                guard let self = self else {
                    return .just([])
                }

                let itemObservables = gyms.map { gym -> Observable<Item> in
                    return self.fetchImageURLUseCase.execute(from: gym.profileImage ?? "")
                        .asObservable()
                        .do(onNext: { imageURLString in
                     
                        })
                        .map { imageURLString in
                            return Item(type: .gym,
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

    private func searchGyms(with query: String) -> Observable<[Item]> {

        return fetchGymInfoUseCase.execute(gymName: query)
            .asObservable()
            .flatMap { gym -> Observable<Item?> in

                return self.fetchImageURLUseCase.execute(from: gym.profileImage ?? "")
                    .asObservable()
                    .do(onNext: { imageURLString in
                    })
                    .map { imageURLString in
                        let sanitizedGymName = gym.gymName.replacingOccurrences(of: " ", with: "").lowercased()
                        let sanitizedQuery = query.replacingOccurrences(of: " ", with: "").lowercased()

                        if sanitizedGymName.contains(sanitizedQuery) {
                            return Item(type: .gym,
                                        name: gym.gymName,
                                        imageName: imageURLString ?? "",
                                        location: gym.address,
                                        height: nil)
                        } else {
                            return nil
                        }
                    }
            }
            .compactMap { $0 }
            .toArray()
            .asObservable()
            .catch { error in
                print("검색중 오류 발생: \(error)")
                return Observable.just([])
            }
    }
   
    private func searchUsers(with query: String) -> Observable<[Item]> {
        return userSearchUseCase.execute(with: query)
            .map { users in
                return users.map { user in
                    return Item(type: .user,
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
