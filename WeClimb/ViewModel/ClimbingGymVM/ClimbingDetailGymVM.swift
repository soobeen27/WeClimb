//
//  ClimbingGymDetailVM.swift
//  WeClimb
//
//  Created by 머성이 on 9/1/24.
//

import UIKit

import RxCocoa
import RxSwift
import FirebaseFirestore

class ClimbingDetailGymVM {
    
    struct Output {
        let gymName: Driver<String>
        let logoImageURL: Driver<URL>
        let problemThumbnails: Driver<[URL]>
    }
    
    let gymNameRelay = BehaviorRelay<String>(value: "")
    private let logoImageURLRelay = BehaviorRelay<URL?>(value: nil)
    private let problemThumbnailsRelay = BehaviorRelay<[URL]>(value: [])
    private var currentFilterConditions = FilterConditions()
    private let disposeBag = DisposeBag()
    
    // Output
    let output: Output
    let grade: String
    
    var gymName: String {
        return gymNameRelay.value
    }
    
    init(gym: Gym, grade: String, initialFilterConditions: FilterConditions) {
        self.gymNameRelay.accept(gym.gymName)
        self.grade = grade.colorInfo.englishText
        self.currentFilterConditions = initialFilterConditions
        
        self.output = Output(
            gymName: gymNameRelay.asDriver(),
            logoImageURL: logoImageURLRelay.asDriver().compactMap { $0 },
            problemThumbnails: problemThumbnailsRelay.asDriver()
        )
        
        gymNameRelay.accept(gym.gymName)
        
        if let profileImage = gym.profileImage {
            FirebaseManager.shared.fetchImageURL(from: profileImage) { [weak self] url in
                self?.logoImageURLRelay.accept(url)
            }
        }
        
//        if initialFilterConditions.holdColor == nil &&
//            initialFilterConditions.heightRange == nil &&
//            initialFilterConditions.armReachRange == nil {
//            // 필터 조건이 없으면 기본 로드
            loadMediaURLs(for: gymName, grade: grade)
//        } else {
//            // 필터 조건이 있으면 필터 적용
//            applyFilters(filterConditions: initialFilterConditions)
//        }
    }
    
    func updateFilterConditions(_ newConditions: FilterConditions) {
        currentFilterConditions = newConditions
    }
    
    func getCurrentFilterConditions() -> FilterConditions {
        return currentFilterConditions
    }
    
    func applyFilters(filterConditions: FilterConditions) {
        let mappedHoldColor = filterConditions.holdColor.map { holdColor in
            "\(holdColor.capitalized)"
        }

        let heightCondition = filterConditions.heightRange.flatMap { $0 == (0, 200) ? nil : $0 }
        let armReachCondition = filterConditions.armReachRange.flatMap { $0 == (0, 200) ? nil : $0 }

        print("[DEBUG] Applying Filters - GymName: \(gymNameRelay.value), Grade: \(grade), Hold: \(mappedHoldColor ?? "None")")
        print("[DEBUG] HeightRange: \(String(describing: heightCondition)), ArmReachRange: \(String(describing: armReachCondition))")

        
        FirebaseManager.shared.getFilteredPost(
            gymName: gymNameRelay.value,
            grade: grade,
            hold: mappedHoldColor,
            height: heightCondition.map { [$0.0, $0.1] },
            armReach: armReachCondition.map { [$0.0, $0.1] },
            completion: { _ in }
        )
        .subscribe(onSuccess: { [weak self] filteredPosts in
            guard let self = self else { return }
            print("Filtered Posts Count: \(filteredPosts.count)")
            let thumbnailURLs = filteredPosts.compactMap { URL(string: $0.thumbnail ?? "") }
            print("[DEBUG] Filtered Thumbnail URLs: \(thumbnailURLs)")

            self.problemThumbnailsRelay.accept(thumbnailURLs)
        }, onFailure: { error in
            print("필터링된 데이터 로드 실패: \(error)")
        })
        .disposed(by: disposeBag)
    }
    
    // 초기 미디어 데이터 로드
    private func loadMediaURLs(for gymName: String, grade: String) {
        FirebaseManager.shared.getFilteredPost(
            gymName: gymName,
            grade: grade,
            completion: { _ in}
        )
        .subscribe(onSuccess: { [weak self] medias in
            guard let self = self else { return }
            let thumbnailURLs = medias.compactMap { media in
                URL(string: media.thumbnail ?? "")
            }
            self.problemThumbnailsRelay.accept(thumbnailURLs)
        }, onFailure: { error in
            print("초기 미디어 데이터 로드 실패: \(error)")
        })
        .disposed(by: disposeBag)
    }
}

extension ClimbingDetailGymVM {
    static func create(gym: Gym, grade: String, hold: String?) -> ClimbingDetailGymVM {
        let initialFilterConditions = FilterConditions(
            holdColor: hold,
            heightRange: nil,
            armReachRange: nil
        )
        
        return ClimbingDetailGymVM(
            gym: gym,
            grade: grade,
            initialFilterConditions: initialFilterConditions
        )
    }
}
