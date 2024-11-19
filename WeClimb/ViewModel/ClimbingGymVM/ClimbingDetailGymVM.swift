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
    
    private let gymNameRelay = BehaviorRelay<String>(value: "")
    private let logoImageURLRelay = BehaviorRelay<URL?>(value: nil)
    private let problemThumbnailsRelay = BehaviorRelay<[URL]>(value: [])
    private let disposeBag = DisposeBag()
    
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
        
        // 특정 Gym과 grade에 맞는 미디어 URL 로드
                loadMediaURLs(for: gym.gymName, grade: grade)
            }
            
    private func loadMediaURLs(for gymName: String, grade: String) {
//        FirebaseManager.shared.getFilteredPost(gymName: gymName, grade: grade)
//            .subscribe(onSuccess: { [weak self] medias in
//                guard let self = self else { return }
//                
//                // 각 Media 객체의 썸네일 URL을 HTTPS 형식으로 변환하여 저장
////                let thumbnailURLs: [URL] = medias.compactMap { media in
////                    if let thumbnailURLString = media.thumbnailURL {
////                        return URL(string: thumbnailURLString)
////                    }
////                    return nil
////                }
////                
////                print("Fetched Thumbnail URLs:", thumbnailURLs)
////                self.problemThumbnailsRelay.accept(thumbnailURLs)
//                
//            }, onFailure: { error in
//                print("미디어 URL 가져오기 오류: \(error)")
//            })
//            .disposed(by: disposeBag)
    }
}
