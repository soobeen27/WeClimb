//
//  MainFeedVC_SF.swift
//  WeClimb
//
//  Created by 김솔비 on 9/5/24.
//

import UIKit

import FirebaseAuth
import SnapKit
import RxCocoa
import RxSwift

class SFMainFeedVC: UIViewController{
    
    private let disposeBag = DisposeBag()
    
    var viewModel: MainFeedVM
    var isRefresh = false
    var startingIndex: Int
    private let feedType: FeedType
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0  // 셀 간 여백 조정

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(hex: "#0B1013")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
        
        return collectionView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.center = CGPoint(x: collectionView.frame.width / 2, y: 50)
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0B1013")
        setNavigationBar()
        setTabBar()
        setCollectionView()
        setLayout()
        bindCollectionView()
        setupCollectionViewScrollEvent()
        setupCollectionView()
        buttonBind()
        feedLoading()
        gymImageTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        innerCollectionViewPlayers(playOrPause: false) // 비디오 정지
    }
    
    init(viewModel: MainFeedVM, startingIndex: Int = 0, feedType: FeedType) {
        self.viewModel = viewModel
        self.feedType = feedType
        self.startingIndex = startingIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func feedLoading() {
        if feedType == .mainFeed {
            viewModel.mainFeed()
        }
    }
    
    //MARK: - 네비게이션바, 탭바 세팅
    private func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setTabBar(){
        if let tabBar = self.tabBarController?.tabBar {
            tabBar.backgroundImage = UIImage()  //탭바 배경 투명하게 설정
            tabBar.shadowImage = UIImage()  //탭바 하단 그림자 제거
            tabBar.isTranslucent = true  //탭바 반투명
            tabBar.backgroundColor = .clear  //탭바 배경투명
            //            tabBar.backgroundColor = UIColor(hex: "#0B1013")
        }
    }
    
    //MARK: - 컬렉션뷰 & 레이아웃 설정
    private func setCollectionView() {
        collectionView.register(SFCollectionViewCell.self, forCellWithReuseIdentifier: SFCollectionViewCell.className)
        
        collectionView.frame = view.bounds  //컬렉션뷰 셀 프레임을 화면 전체에 맞춤
        collectionView.isPagingEnabled = true  //스크롤 시 한 화면씩 넘기기(페이징 모드 활성화)
        collectionView.contentInsetAdjustmentBehavior = .never  //네비게이션바 자동 여백 삭제
        collectionView.showsHorizontalScrollIndicator = false //스크롤바 숨김 옵션
        collectionView.backgroundColor = UIColor(hex: "#0B1013")
        collectionView.addSubview(activityIndicator)
    }
    
    private func gymImageTap() {
        viewModel.gymButtonTap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { gymName in
                guard let gymName else { return }
                FirebaseManager.shared.gymInfo(from: gymName) { [weak self] gym in
                    guard let self, let gym else { return }
                    DispatchQueue.main.async {
                        let climbingGymVC = ClimbingGymVC()
                        climbingGymVC.configure(with: gym)
                        
                        self.navigationController?.navigationBar.prefersLargeTitles = false
                        self.navigationController?.navigationBar.tintColor = .systemBlue
                        self.navigationController?.pushViewController(climbingGymVC, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindCollectionView() {
        viewModel.posts
            .asDriver()
            .drive(collectionView.rx
                .items(cellIdentifier: SFCollectionViewCell.className,
                       cellType: SFCollectionViewCell.self)) { [weak self] index, post, cell in
                guard let self else { return }
                cell.configure(with: post, viewModel: self.viewModel)
            }
            .disposed(by: disposeBag)

        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionViewScrollEvent() {
        collectionView.rx.contentOffset
            .asDriver()
            .drive(onNext: { [weak self] contentOffset in
                guard let self else { return }
                
                let scrollViewHeight = self.collectionView.frame.size.height
                let scrollContentSizeHeight = self.collectionView.contentSize.height
                let scrollOffsetThreshold = scrollContentSizeHeight - scrollViewHeight
                
                // 스크롤이 마지막 셀에 도달했는지 확인
                if contentOffset.y >= scrollOffsetThreshold {
                    if self.collectionView.indexPathsForVisibleItems.sorted().last != nil {
                        self.viewModel.isLastCell.accept(true)
                    } else {
                        self.viewModel.isLastCell.accept(false)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func buttonBind() {
        collectionView.rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] (cell, indexPath) in
                guard let self,
                      let sfCell = cell as? SFCollectionViewCell
                else { return }
                var input: MainFeedVM.Input
                input = MainFeedVM.Input(
                    reportDeleteButtonTap: sfCell.reportDeleteButtonTap,
                    commentButtonTap: sfCell.commentButtonTap,
                    profileTap: sfCell.profileTap
                )
                let output = self.viewModel.transform(input: input)
                
                output.presentReport.drive(onNext: { [weak self] post in
                    guard let self, let post else { return }
                    self.actionSheet(for: post)
                })
                .disposed(by: sfCell.disposeBag)

                output.presentComment.drive(onNext: { [weak self] post in
                    guard let self, let post else { return }
                    self.showCommentModal(for: post)
                })
                .disposed(by: sfCell.disposeBag)
                
                output.pushProfile
                    .drive(onNext: { name in
                    guard let name else { return }
                    let userPageVM = UserPageVM()
                    userPageVM.fetchUserInfo(userName: name)
                    
                    let userPageVC = UserPageVC(viewModel: userPageVM)
                    
                    self.navigationController?.navigationBar.prefersLargeTitles = false
                    self.navigationController?.pushViewController(userPageVC, animated: true)
                })
                .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
    }

    
    private func setLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            //            $0.edges.equalToSuperview()
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    //MARK: - 더보기 액션 시트
    private func actionSheet(for post: Post) {
        var actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        guard let user = Auth.auth().currentUser else { return }
        
        switch feedType {
        case .mainFeed:
            if post.authorUID == user.uid {
                actionSheet = deleteActionSheet(post: post)
            } else {
                actionSheet = reportBlockActionSheet(post: post)
            }
        case .myPage:
            actionSheet = deleteActionSheet(post: post)
        case .userPage:
            actionSheet = reportBlockActionSheet(post: post)
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func deleteActionSheet(post: Post) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.viewModel.deletePost(uid: post.postUID)
                .asDriver(onErrorDriveWith: .empty())
                .drive(onNext: { _ in
                    CommonManager.shared.showAlert(from: self, title: "알림", message: "게시물이 삭제되었습니다.") {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                .disposed(by: self.disposeBag)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [deleteAction, cancelAction]
            .forEach {
                actionSheet.addAction($0)
            }
        return actionSheet
    }
    
    private func reportBlockActionSheet(post: Post) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
//            self?.reportModal()
            let modalVC = FeedReportModalVC()
            self?.presentModal(modalVC: modalVC)
        }
        let blockAction = UIAlertAction(title: "차단하기", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.blockUser(authorUID: post.authorUID)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [reportAction, blockAction, cancelAction]
            .forEach {
                actionSheet.addAction($0)
            }
        return actionSheet
    }
    
    // MARK: - 신고하기 및 댓글 모달 표시
    private func showCommentModal(for post: Post) {
        let modalVC = CommentModalVC(viewModel: CommentVM(post: post))
        presentModal(modalVC: modalVC)
    }
    
    func innerCollectionViewPlayers(playOrPause: Bool) {
        // 현재 보이는 셀을 가져옴
        guard let visibleCells = collectionView.visibleCells as? [SFCollectionViewCell] else { return }
        
        // 각 셀 안의 AVPlayer 일시정지
        visibleCells.forEach { cell in
            let innerCollectionView = cell.collectionView
            guard let innerVisibleCells = innerCollectionView.visibleCells as? [SFFeedCell] else { return }
            
            if playOrPause {
                if let cell = innerVisibleCells.last {
                    cell.playVideo()
                }
            } else {
                innerVisibleCells.forEach { innerCell in
                    innerCell.stopVideo()
                }
            }
        }
    }
    
    
    //MARK: - 차단하기 관련 메서드
    private func blockUser(authorUID: String) {
        FirebaseManager.shared.addBlackList(blockedUser: authorUID) { [weak self] success in
            guard let self else { return }
            
            if success {
                print("차단 성공: \(authorUID)")
                CommonManager.shared.showAlert(from: self, title: "차단 완료", message: "")
            } else {
                print("차단 실패: \(authorUID)")
                CommonManager.shared.showAlert(from: self, title: "차단 실패", message: "차단을 실패했습니다. 다시 시도해주세요.")
            }
        }
    }
}


//MARK: - 컬렉션뷰 델리게이트 설정

extension SFMainFeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        innerCollectionViewPlayers(playOrPause: false)
    }
    // 스크롤바 위로 땡겼을때 리로딩 JS
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.contentOffset.y < -100 {
            activityIndicator.startAnimating()
            if feedType == .mainFeed {
                viewModel.fetchInitialFeed()
                isRefresh = true
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        activityIndicator.stopAnimating()
        if feedType == .mainFeed {
            isRefresh = false
        }
    }
    
}

extension SFMainFeedVC {
    func setupCollectionView() {
        collectionView.reloadData()
//        if !viewModel.shouldFetch {
        if feedType != .mainFeed {
            DispatchQueue.main.async {
                self.collectionView.isPagingEnabled = false
                let startingIndexPath = IndexPath(row: self.startingIndex, section: 0)
                self.collectionView.scrollToItem(at: startingIndexPath, at: .top, animated: false)
                self.collectionView.isPagingEnabled = true
            }
        }
    }
}
