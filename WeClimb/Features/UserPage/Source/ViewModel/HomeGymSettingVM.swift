//
//  HomeGymSettingVM.swift
//  WeClimb
//
//  Created by 윤대성 on 2/25/25.
//

import UIKit

import RxCocoa
import RxSwift

protocol HomeGymSettingInput {
    var searchQuery: Observable<String> { get }
    var selectHomeGymImage: Observable<Gym> { get }
}

protocol HomeGymSettingOutput {
    var gyms: Driver<[Gym]> { get }
    var filteredGyms: Driver<[Gym]> { get }
    var selectedHomeGymImage: Driver<Gym?> { get }
    var gymImageURLs: Driver<[String: URL?]> { get }
}

protocol HomeGymSettingVM {
    func transform(input: HomeGymSettingInput) -> HomeGymSettingOutput
}

class HomeGymSettingImpl: HomeGymSettingVM {
    
    private let disposeBag = DisposeBag()
    
    private let fetchAllGymsInfoUseCase: FetchAllGymsInfoUseCase
    private let searchGymsUseCase: SearchGymsUseCase
    private let fetchImageURLUseCase: FetchImageURLUseCase
    
    private let cachedGymsRelay = BehaviorRelay<[Gym]>(value: [])
    private let gymImageURLsRelay = BehaviorRelay<[String: URL?]>(value: [:])

    init(fetchAllGymsInfoUseCase: FetchAllGymsInfoUseCase, searchGymsUseCase: SearchGymsUseCase, fetchImageURLUseCase: FetchImageURLUseCase) {
        self.fetchAllGymsInfoUseCase = fetchAllGymsInfoUseCase
        self.searchGymsUseCase = searchGymsUseCase
        self.fetchImageURLUseCase = fetchImageURLUseCase
    }
    
    struct Input: HomeGymSettingInput {
        let searchQuery: Observable<String>
        let selectHomeGymImage: Observable<Gym>
    }
    
    struct Output: HomeGymSettingOutput {
        let gyms: Driver<[Gym]>
        let filteredGyms: Driver<[Gym]>
        let selectedHomeGymImage: Driver<Gym?>
        let gymImageURLs: Driver<[String: URL?]>
    }
    
    func transform(input: HomeGymSettingInput) -> HomeGymSettingOutput {
        let gymsRelay = BehaviorRelay<[Gym]>(value: [])
        let filteredGymsRelay = BehaviorRelay<[Gym]>(value: [])
        let selectedGymRelay = BehaviorRelay<Gym?>(value: nil)

        let cachedObservable = Observable.just(cachedGymsRelay.value)


        let fetchObservable = fetchAllGymsInfoUseCase.execute()
            .do(onSuccess: { [weak self] gyms in
                self?.cachedGymsRelay.accept(gyms)
                self?.fetchGymImages(gyms: gyms)
            })
            .asObservable()

        let combinedGymsObservable = Observable.concat(cachedObservable, fetchObservable)
            .share(replay: 1, scope: .whileConnected)

        combinedGymsObservable
            .bind(to: gymsRelay)
            .disposed(by: disposeBag)

        input.searchQuery
            .distinctUntilChanged()
            .flatMapLatest { query in
                return combinedGymsObservable.map { gyms in
                    gyms.filter { $0.gymName.contains(query) }
                }
            }
            .bind(to: filteredGymsRelay)
            .disposed(by: disposeBag)

        input.selectHomeGymImage
            .bind(to: selectedGymRelay)
            .disposed(by: disposeBag)

        return Output(
            gyms: gymsRelay.asDriver(),
            filteredGyms: filteredGymsRelay.asDriver(),
            selectedHomeGymImage: selectedGymRelay.asDriver(),
            gymImageURLs: gymImageURLsRelay.asDriver()
        )
    }

    private func fetchGymImages(gyms: [Gym]) {
        let imageFetches = gyms.map { gym in
            fetchImageURLUseCase.execute(from: gym.profileImage ?? "")
                .map { urlString -> (String, URL?) in
                    guard let urlString = urlString, urlString.hasPrefix("https://") else {
                        return (gym.gymName, nil)
                    }
                    return (gym.gymName, URL(string: urlString))
                }
                .asObservable()
        }

        Observable.merge(imageFetches)
            .subscribe(onNext: { [weak self] gymName, url in
                var updatedURLs = self?.gymImageURLsRelay.value ?? [:]
                updatedURLs[gymName] = url
                self?.gymImageURLsRelay.accept(updatedURLs)
            })
            .disposed(by: disposeBag)
    }
}
