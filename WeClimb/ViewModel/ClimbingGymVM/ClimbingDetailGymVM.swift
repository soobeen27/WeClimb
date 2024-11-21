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
    private let disposeBag = DisposeBag()
    
    // Output
    let output: Output
    let grade: String
    
    var gymName: String {
        return gymNameRelay.value
    }
    
    init(gym: Gym, grade: String) {
        self.gymNameRelay.accept(gym.gymName)
        self.grade = grade.colorInfo.englishText
        
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
        
        loadMediaURLs(for: gym.gymName, grade: self.grade)
    }
    
    // 필터 적용 메서드
    func applyFilters(filterConditions: FilterConditions) {
        FirebaseManager.shared.getFilteredPost(
            gymName: gymNameRelay.value,
            grade: grade,
            hold: filterConditions.holdColor,
            height: filterConditions.heightRange.map { [$0.0, $0.1] },
            armReach: filterConditions.armReachRange.map { [$0.0, $0.1] },
            completion: { _ in }
        )
        .subscribe(onSuccess: { [weak self] filteredPosts in
            guard let self = self else { return }
            let thumbnailURLs = filteredPosts.compactMap { post in
                URL(string: post.thumbnail ?? "")
            }
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
