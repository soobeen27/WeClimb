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
        let searchQuery: Observable<String> // ✅ 사용자가 검색어 입력
        let selectHomeGymImage: Observable<Gym>
    }
    
    struct Output: HomeGymSettingOutput {
        let gyms: Driver<[Gym]>          // ✅ 전체 암장 리스트
        let filteredGyms: Driver<[Gym]>  // ✅ 검색 결과 리스트
        let selectedHomeGymImage: Driver<Gym?>
        let gymImageURLs: Driver<[String: URL?]>
    }
    
    func transform(input: HomeGymSettingInput) -> HomeGymSettingOutput {
        let gymsRelay = BehaviorRelay<[Gym]>(value: [])
        let filteredGymsRelay = BehaviorRelay<[Gym]>(value: [])
        let selectedGymRelay = BehaviorRelay<Gym?>(value: nil)

        // ✅ 1. 캐싱된 데이터 먼저 반환
        let cachedObservable = Observable.just(cachedGymsRelay.value)

        // ✅ 2. 네트워크 요청을 통해 최신 데이터 가져오기
        let fetchObservable = fetchAllGymsInfoUseCase.execute()
            .do(onSuccess: { [weak self] gyms in
                self?.cachedGymsRelay.accept(gyms) // ✅ 새로운 데이터 캐싱
                self?.fetchGymImages(gyms: gyms)   // ✅ 이미지 URL 가져오기
            })
            .asObservable()

        // ✅ 3. 캐싱된 데이터 → 최신 데이터 순으로 반환
        let combinedGymsObservable = Observable.concat(cachedObservable, fetchObservable)
            .share(replay: 1, scope: .whileConnected) // ✅ 중복 요청 방지

        combinedGymsObservable
            .bind(to: gymsRelay)
            .disposed(by: disposeBag)

        // ✅ 4. 검색 기능 (캐싱된 데이터 + 최신 데이터 반영)
        input.searchQuery
            .distinctUntilChanged()
            .flatMapLatest { query in
                return combinedGymsObservable.map { gyms in
                    gyms.filter { $0.gymName.contains(query) }
                }
            }
            .bind(to: filteredGymsRelay)
            .disposed(by: disposeBag)

        // ✅ 5. 선택된 홈짐 업데이트
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

    // ✅ 6. 이미지 URL 가져오기 (Firebase Storage)
    private func fetchGymImages(gyms: [Gym]) {
        let imageFetches = gyms.map { gym in
            fetchImageURLUseCase.execute(from: gym.profileImage ?? "")
                .map { urlString -> (String, URL?) in
                    guard let urlString = urlString, urlString.hasPrefix("https://") else {
                        return (gym.gymName, nil) // ✅ `https://`가 아니면 nil 반환
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
