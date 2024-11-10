//
//  ClimbingGymDetailVM.swift
//  WeClimb
//
//  Created by 머성이 on 9/1/24.
//

import UIKit

import RxCocoa
import RxSwift

class ClimbingDetailGymVM {
    struct Output {
        let gymName: Driver<String>
        let logoImageURL: Driver<URL>
        let problemThumbnails: Driver<[URL]>
    }
    
    private let gymNameRelay = BehaviorRelay<String>(value: "")
    private let logoImageURLRelay = BehaviorRelay<URL?>(value: nil)
    private let problemThumbnailsRelay = BehaviorRelay<[URL]>(value: [])
    
    let output: Output
    
    init(gym: Gym, grade: String) {
        // Output 정의
        output = Output(
            gymName: gymNameRelay.asDriver(),
            logoImageURL: logoImageURLRelay.asDriver().compactMap { $0 },
            problemThumbnails: problemThumbnailsRelay.asDriver()
        )
        
        // Gym 정보 설정
        gymNameRelay.accept(gym.gymName)
        
        // profileImage (gs:// URL) 변환하여 사용
        if let profileImage = gym.profileImage {
            FirebaseManager.shared.fetchImageURL(from: profileImage) { [weak self] url in
                if let url = url {
                    self?.logoImageURLRelay.accept(url)
                }
            }
        }
        
        // 문제 썸네일 가져오기
//        fetchProblems(for: gym, grade: grade)
    }
    
//    private func fetchProblems(for gym: Gym, grade: String) {
//        FirebaseManager.shared.fetchProblems(for: gym.gymName, grade: grade) { [weak self] urls in
//            self?.problemThumbnailsRelay.accept(urls)
//        }
//    }
}
