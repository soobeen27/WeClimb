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
    
    let gymNameRelay = BehaviorRelay<String>(value: "")
    let logoImageURLRelay = BehaviorRelay<URL?>(value: nil)
    let postRelay = PublishRelay<[Post]>()
    
    private var currentFilterConditions = FilterConditions()
    private let disposeBag = DisposeBag()
    
    let grade: String
    let hold: String?
    let gym: Gym
    
    init(gym: Gym, grade: String, hold: String?, initialFilterConditions: FilterConditions) {
        self.gym = gym
        self.grade = grade.colorInfo.englishText
        self.hold = hold
        self.currentFilterConditions = initialFilterConditions
        
        gymNameRelay.accept(gym.gymName)
        
        if let profileImage = gym.profileImage {
            FirebaseManager.shared.fetchImageURL(from: profileImage) { [weak self] url in
                self?.logoImageURLRelay.accept(url)
            }
        }
        
        loadMediaURLs(for: gym.gymName, grade: grade, hold: hold)
    }
    
    func updateFilterConditions(_ newConditions: FilterConditions) {
        currentFilterConditions = newConditions
    }
    
    func getCurrentFilterConditions() -> FilterConditions {
        return currentFilterConditions
    }
    
    func applyFilters(filterConditions: FilterConditions) {
        guard let holdColor = filterConditions.holdColor else {
            print("홀드 값이 없습니다.")
            loadMediaURLs(for: gym.gymName, grade: grade, hold: hold)
            return
        }
        let formattedHold = "hold\(holdColor.capitalized)"
        print("적용된 홀드 값: \(formattedHold)")

        let heightCondition = filterConditions.heightRange.flatMap { $0 == (0, 200) ? nil : $0 }
        let armReachCondition = filterConditions.armReachRange.flatMap { $0 == (0, 200) ? nil : $0 }
        
        FirebaseManager.shared.getFilteredPost(
            gymName: gym.gymName,
            grade: grade,
            hold: formattedHold,
            height: heightCondition.map { [$0.0, $0.1] },
            armReach: armReachCondition.map { [$0.0, $0.1] },
            completion: { _ in }
        )
        .subscribe(onSuccess: { [weak self] filteredPosts in
            guard let self = self else { return }
            print("재현 필터 조건\(filteredPosts)")
            self.postRelay.accept(filteredPosts)
            
            let thumbnailURLs = filteredPosts.compactMap { $0.thumbnail }
            print("가져온 썸네일 URL들: \(thumbnailURLs)")
        }, onFailure: { error in
            print("필터링된 데이터 로드 실패: \(error)")
        })
        .disposed(by: disposeBag)
    }
    
    // 초기 미디어 데이터 로드
    private func loadMediaURLs(for gymName: String, grade: String, hold: String? = nil) {
        FirebaseManager.shared.getFilteredPost(
            gymName: gymName,
            grade: grade,
            hold: hold,
            completion: { _ in }
        )
        .subscribe(onSuccess: { [weak self] medias in
            guard let self = self else { return }
            let thumbnailURLs = medias.compactMap { media in
                URL(string: media.thumbnail ?? "")
            }
            self.postRelay.accept(medias)
        }, onFailure: { error in
            print("초기 미디어 데이터 로드 실패: \(error)")
        })
        .disposed(by: disposeBag)
    }
}

