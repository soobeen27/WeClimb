//
//  ClimbingFilterVM.swift
//  WeClimb
//
//  Created by 머성이 on 11/11/24.
//

import UIKit

import RxCocoa
import RxSwift

class ClimbingFilterVM {
    // MARK: - Input
    struct Input {
        let holdSelected: AnyObserver<String?>
        let heightRangeSelected: AnyObserver<(Int, Int)>
        let armReachRangeSelected: AnyObserver<(Int, Int)>
        let fetchFilteredPosts: AnyObserver<Void>
    }
    
    // MARK: - Output
    struct Output {
        let filteredPosts: Driver<[Post]>
    }
    
    let input: Input
    let output: Output
    
    private let holdSelectedSubject = PublishSubject<String?>()
    private let heightRangeSubject = PublishSubject<(Int, Int)>()
    private let armReachRangeSubject = PublishSubject<(Int, Int)>()
    private let fetchFilteredPostsSubject = PublishSubject<Void>()
    private let filteredPostsSubject = PublishSubject<[Post]>()
    
    private let gymName: String
    private let grade: String
    private let disposeBag = DisposeBag()
    
    init(gymName: String, grade: String) {
        self.gymName = gymName
        self.grade = grade
        
        self.input = Input(
            holdSelected: holdSelectedSubject.asObserver(),
            heightRangeSelected: heightRangeSubject.asObserver(),
            armReachRangeSelected: armReachRangeSubject.asObserver(),
            fetchFilteredPosts: fetchFilteredPostsSubject.asObserver()
        )
        
        self.output = Output(
            filteredPosts: filteredPostsSubject.asDriver(onErrorJustReturn: [])
        )
        
        // Combine filters and fetch posts
//        fetchFilteredPostsSubject
//            .withLatestFrom(
//                Observable.combineLatest(
//                    holdSelectedSubject.startWith(nil),
//                    heightRangeSubject.startWith((120, 200)),
//                    armReachRangeSubject.startWith((120, 200))
//                )
//            )
//            .flatMapLatest { [weak self] hold, heightRange, armReachRange in
//                guard let self = self else { return Observable.just([]) }
//                return FirebaseManager.shared.getFilteredPost(
//                    gymName: self.gymName,
//                    grade: self.grade,
//                    hold: hold,
//                    height: [heightRange.0, heightRange.1],
//                    armReach: [armReachRange.0, armReachRange.1],
//                    completion: { _ in }
//                ).asObservable() // Single -> Observable 변환
//            }
//            .bind(to: filteredPostsSubject) // PublishSubject와 연결
//            .disposed(by: disposeBag)
    }
}
