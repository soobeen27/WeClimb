//
//  UserFeedCellVM.swift
//  WeClimb
//
//  Created by 윤대성 on 1/24/25.
//
//
//import UIKit
//
//import RxCocoa
//import RxSwift
//
//protocol UserFeedCellVM {
//    func transform(input: UserFeedInput) -> UserFeedOutput
//}
//
//protocol UserFeedInput {
//    var fetchTrigger: PublishRelay<Void> { get }
//}
//
//protocol UserFeedOutput {
//    var date: Driver<String> {get}
//    var badges: Driver<[Badge]> {get}
//    var likeCount: Driver<String> {get}
//    var commentCount: Driver<String> {get}
//}
//
//struct Badge {
//    let name: String
//    let color: UIColor
//    let thumbnailURL: URL?
//}
//
//class UserFeedCellVMImpl: UserFeedCellVM {
//    private let fetchTrigger = PublishRelay<Void>()
//    
//    private let dateSubject = BehaviorSubject<String>(value: "")
//    private let badgesSubject = BehaviorSubject<[Badge]>(value: [])
//    private let likeCountSubject = BehaviorSubject<String>(value: "0")
//    private let commentCountSubject = BehaviorSubject<String>(value: "0")
//    
//    private let disposeBag = DisposeBag()
//    
//    struct Input: UserFeedInput {
//        let fetchTrigger: PublishRelay<Void>
//    }
//    
//    struct Output: UserFeedOutput {
//        let date: Driver<String>
//        let badges: Driver<[Badge]>
//        let likeCount: Driver<String>
//        let commentCount: Driver<String>
//    }
//    
//    func transform(input: UserFeedInput) -> UserFeedOutput {
//        input.fetchTrigger
//            .bind(to: fetchTrigger)
//            .disposed(by: disposeBag)
//        
//        // fetchTrigger에 따라 Firebase에서 데이터 로드
//        fetchTrigger
//            .flatMap { _ in
//                // Firebase 데이터 로드 (Mock 데이터로 대체)
//                return Observable.just(UserFeedCellViewModel.mockData())
//            }
//            .subscribe(onNext: { [weak self] data in
//                self?.dateSubject.onNext(data.date)
//                self?.badgesSubject.onNext(data.badges)
//                self?.likeCountSubject.onNext("\(data.likeCount)")
//                self?.commentCountSubject.onNext("\(data.commentCount)")
//            })
//            .disposed(by: disposeBag)
//        
//        return Output(
//            date: dateSubject.asDriver(onErrorJustReturn: ""),
//            badges: badgesSubject.asDriver(onErrorJustReturn: []),
//            likeCount: likeCountSubject.asDriver(onErrorJustReturn: "0"),
//            commentCount: commentCountSubject.asDriver(onErrorJustReturn: "0")
//        )
//    }
//    
//    private static func mockData() -> (date: String, badges: [Badge], likeCount: Int, commentCount: Int) {
//        let badges = [
//            Badge(name: "암장이름", color: .red, thumbnailURL: URL(string: "https://example.com/image1")),
//        ]
//        return ("2024.12.12.", badges, 342, 17)
//    }
//}

//
//func bind(to viewModel: UserFeedCellViewModelType) {
//    let input = Input(fetchTrigger: PublishRelay<Void>())
//    let output = viewModel.transform(input: input)
//
//    // Output 바인딩
//    output.date
//        .drive(dateLabel.rx.text)
//        .disposed(by: disposeBag)
//
//    output.badges
//        .drive(collectionView.rx.items(cellIdentifier: "UserTableFeedCollectionCell", cellType: UserTableFeedCollectionCell.self)) { index, badge, cell in
//            cell.configure(with: badge)
//        }
//        .disposed(by: disposeBag)
//
//    output.likeCount
//        .drive(likeLabel.rx.text)
//        .disposed(by: disposeBag)
//
//    output.commentCount
//        .drive(commentLabel.rx.text)
//        .disposed(by: disposeBag)
//
//    // FetchTrigger 실행
//    input.fetchTrigger.accept(())
//}
