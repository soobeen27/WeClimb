//
//  Untitled.swift
//  WeClimb
//
//  Created by 강유정 on 1/21/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol SearchResultInput {
    var query: Observable<String> { get }
    var selectedSegment: Observable<Int> { get }
    var saveItem: Observable<SearchResultItem> { get }
}

protocol SearchResultOutput {
    var items: Observable<[SearchResultItem]> { get }
    var error: Observable<String> { get }
}

protocol SearchResultVM {
    func transform(input: SearchResultInput) -> SearchResultOutput
}

class SearchResultVMImpl: SearchResultVM {
    private let disposeBag = DisposeBag()
    
    private let fetchAllGymsInfoUseCase: FetchAllGymsInfoUseCase
    private let searchGymsUseCase: SearchGymsUseCase
    private let userSearchUseCase: UserSearchUseCase
    private let fetchImageURLUseCase: FetchImageURLUseCase
    
    private var cachedQuery: String = ""
    private var cachedGyms: [SearchResultItem] = []
    private var cachedUsers: [SearchResultItem] = []
    
    private let gymsSubject = BehaviorSubject<[SearchResultItem]>(value: [])
    private let usersSubject = BehaviorSubject<[SearchResultItem]>(value: [])
    
    init(fetchAllGymsInfoUseCase: FetchAllGymsInfoUseCase,
         searchGymsUseCase: SearchGymsUseCase,
         userSearchUseCase: UserSearchUseCase,
         fetchImageURLUseCase: FetchImageURLUseCase) {
        self.fetchAllGymsInfoUseCase = fetchAllGymsInfoUseCase
        self.searchGymsUseCase = searchGymsUseCase
        self.userSearchUseCase = userSearchUseCase
        self.fetchImageURLUseCase = fetchImageURLUseCase
    }
    
    struct Input: SearchResultInput {
        let query: Observable<String>
        let selectedSegment: Observable<Int>
        var saveItem: Observable<SearchResultItem>
    }
    
    struct Output: SearchResultOutput {
        let items: Observable<[SearchResultItem]>
        let error: Observable<String>
    }
    
    func transform(input: SearchResultInput) -> SearchResultOutput {
        let itemsSubject = BehaviorSubject<[SearchResultItem]>(value: [])
        let errorSubject = PublishSubject<String>()
        
        Observable.combineLatest(input.query, input.selectedSegment)
            .distinctUntilChanged { (previous, current) in
                return previous == current
            }
            .flatMapLatest { [weak self] query, segmentIndex -> Observable<[SearchResultItem]> in
                guard let self = self else { return .empty() }
                
                if query != self.cachedQuery {
                    self.cachedGyms = []
                    self.cachedUsers = []
                    self.cachedQuery = query
                }
                
                if query.isEmpty {
                    return Observable.just(self.cachedGyms + self.cachedUsers)
                }
                
                switch segmentIndex {
                case 0:
                    let filteredGyms = self.searchGyms(with: query)
                    let filteredUsers = self.searchUsers(with: query)
                    
                    return Observable.combineLatest(filteredGyms, filteredUsers) { gyms, users in
                        return gyms + users
                    }
                    .catch { error in
                        errorSubject.onNext("Error: \(error.localizedDescription)")
                        return .just([])
                    }
                    
                case 1:
                    return self.searchGyms(with: query)
                        .catch { error in
                            errorSubject.onNext("Error: \(error.localizedDescription)")
                            return .just([])
                        }
                    
                case 2:
                    return self.searchUsers(with: query)
                        .catch { error in
                            errorSubject.onNext("Error: \(error.localizedDescription)")
                            return .just([])
                        }
                    
                default:
                    return .just([])
                }
            }
            .bind(to: itemsSubject)
            .disposed(by: disposeBag)
        
         input.saveItem
             .subscribe(onNext: { [weak self] item in
                 self?.saveSearchResultItem(item: item)
             })
             .disposed(by: disposeBag)
        
        return Output(
            items: itemsSubject.asObservable(),
            error: errorSubject.asObservable()
        )
    }
    
    private func searchGyms(with query: String) -> Observable<[SearchResultItem]> {
        if !cachedGyms.isEmpty {
            let filteredGyms = cachedGyms.filter { $0.name.contains(query) }
            return Observable.just(filteredGyms)
        }
        
        return searchGymsUseCase.execute(query: query)
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
                    .do(onNext: { [weak self] items in
                        self?.cachedGyms = items
                    })
            }
            .catch { error in
                print("검색 중 오류 발생: \(error)")
                return Observable.just([])
            }
    }
    
    private func searchUsers(with query: String) -> Observable<[SearchResultItem]> {
        return userSearchUseCase.execute(with: query)
            .map { users in
                self.cachedUsers = users.map { user in
                    return SearchResultItem(type: .user, name: user.userName ?? "", imageName: user.profileImage ?? "", location: nil, height: user.height)
                }
                self.usersSubject.onNext(self.cachedUsers)
                return self.cachedUsers
            }
            .asObservable()
    }
}

extension SearchResultVMImpl {
    private func saveSearchResultItem(item: SearchResultItem) {
        var savedItems = loadSavedSearchResultItems()
        
        if savedItems.count >= 10 {
            savedItems.removeFirst()
        }
        
        savedItems.append(item)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(savedItems) {
            UserDefaults.standard.set(encoded, forKey: "recentVisitItems")
        }
    }
    
    private func loadSavedSearchResultItems() -> [SearchResultItem] {
        if let savedData = UserDefaults.standard.data(forKey: "recentVisitItems") {
            let decoder = JSONDecoder()
            if let loadedItems = try? decoder.decode([SearchResultItem].self, from: savedData) {
                return loadedItems
            }
        }
        return []
    }
}

