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
    
    var mainFeedVM: MainFeedVM
    var likeVM: LikeViewModel?
    var climbingDetailGymVM: ClimbingDetailGymVM?
    var isRefresh = false
    var startingIndex: Int
    private let feedType: FeedType
    private let loginNeeded = LoginNeeded()
    
    var currentPageIndex: Int = 0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0  // 셀 간 여백 조정

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(hex: "#0B1013")
        collectionView.showsVerticalScrollIndicator = false
//        collectionView.scrollsToTop = false
        
        return collectionView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.center = CGPoint(x: collectionView.frame.width / 2, y: 50)
        return indicator
    }()
    
    private var isCurrentScreenActive: Bool = false
    
    private var isNotMain = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0B1013")
        bindLoadData()
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
        gradeImageTap()
        setNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAllVideos()
        isCurrentScreenActive = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playVisibleVideo(reStart: false)
        print("실행합니다.")
        isCurrentScreenActive = true
    }
    
    init(viewModel: MainFeedVM, startingIndex: Int = 0, feedType: FeedType) {
        self.mainFeedVM = viewModel
        self.feedType = feedType
        self.startingIndex = startingIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func feedLoading() {
        if feedType == .mainFeed {
            mainFeedVM.mainFeed()
        } else if feedType == .filterPage {
            mainFeedVM.filterFeed()
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
    
    private func setNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func didEnterForeground() {
        if isCurrentScreenActive {
            self.playVisibleVideo(reStart: false)
        }
    }
    
    @objc private func didEnterBackground() {
        self.stopAllVideos()
    }
    
    private func gymImageTap() {
        mainFeedVM.gymButtonTap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { gymName in
                guard let gymName else { return }
                FirebaseManager.shared.gymInfo(from: gymName) { [weak self] gym in
                    guard let self, let gym else { return }
                    DispatchQueue.main.async {
                        let climbingGymVC = ClimbingGymVC()
                        climbingGymVC.configure(with: gym)
                        print("GymImageTap")
                        self.navigationController?.navigationBar.prefersLargeTitles = false
                        self.navigationController?.navigationBar.tintColor = .systemBlue
                        self.navigationController?.pushViewController(climbingGymVC, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func gradeImageTap() {
        mainFeedVM.gradeButtonTap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] media in
                guard let self, let media else { return }
                guard let gymName = media.gym, let grade = media.grade, let hold = media.hold else { return }

                print("전달된 데이터 - GymName: \(gymName), Grade: \(grade), Hold: \(hold)")
                
                // Gym 정보 가져오기
                FirebaseManager.shared.gymInfo(from: gymName) { gym in
                    guard let gym else {
                        print("Gym 정보 가져오기 실패")
                        return
                    }
//                    print("가져온 Gym 정보: \(gym)")

                    // FilterConditions 설정
                    let initialFilterConditions = FilterConditions(
                        holdColor: hold,
                        heightRange: nil,
                        armReachRange: nil
                    )

                    let detailViewModel = ClimbingDetailGymVM(
                        gym: gym,
                        grade: grade,
                        hold: hold,
                        initialFilterConditions: initialFilterConditions
                    )
                    let climbingDetailGymVC = ClimbingDetailGymVC(viewModel: detailViewModel)
                    climbingDetailGymVC.configure(with: gymName, grade: grade)

                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(climbingDetailGymVC, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLoadData() {
        mainFeedVM.completedLoad
            .take(1)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                if self.currentPageIndex == 0 {
                    print("커런트페이지인덱스: \(self.currentPageIndex)")
                    self.playVisibleVideo(reStart: true)
                }
            })
            .disposed(by: disposeBag)
        
        if feedType == .myPage || feedType == .userPage {
//            if isplay {
//                self.isplay = false
                mainFeedVM.completedLoad
                    .take(1)
                    .subscribe(onNext: { [weak self] in
                        guard let self else { return }
                        print("마이페이지 혹은 유저페이지")
                        stopAllVideos()
                        self.playVisibleVideo(reStart: true)
                    })
                    .disposed(by: disposeBag)
//            }
        }
    }
    
    private func bindCollectionView() {
        mainFeedVM.posts
            .asDriver()
            .drive(collectionView.rx
                .items(cellIdentifier: SFCollectionViewCell.className,
                       cellType: SFCollectionViewCell.self)) { [weak self] index, post, cell in
                guard let self else { return }
                cell.configure(with: post, viewModel: self.mainFeedVM)
                    if let _ = Auth.auth().currentUser {
                        cell.setLikeButton()
                    } else {
                        cell.likeButton.isEnabled = false
                    cell.likeButton.isActivated = false
                    cell.likeButton.rx.tap
                        .asDriver()
                        .drive(onNext: {
                            self.loginNeeded.loginAlert(vc: self)
                        })
                        .disposed(by: cell.disposeBag)
                }
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
                        self.mainFeedVM.isLastCell.accept(true)
                    } else {
                        self.mainFeedVM.isLastCell.accept(false)
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
                      let sfCell = cell as? SFCollectionViewCell,
                      !sfCell.isBind
                else { return }
                sfCell.isBind = true
                var input: MainFeedVM.Input
                input = MainFeedVM.Input(
                    reportDeleteButtonTap: sfCell.reportDeleteButtonTap,
                    commentButtonTap: sfCell.commentButtonTap,
                    profileTap: sfCell.profileTap
                )
                let output = self.mainFeedVM.transform(input: input)
                
                output.presentReport.asSignal(onErrorSignalWith: .empty()).emit(onNext: { [weak self] post in
                    guard let self, let post else { return }
                    if !self.loginNeeded.loginAlert(vc: self) {
                        self.actionSheet(for: post)
                    }
                })
                .disposed(by: sfCell.disposeBag)

                output.presentComment.asSignal(onErrorSignalWith: .empty()).emit(onNext: { [weak self] post in
                    guard let self, let post else { return }
                    if !self.loginNeeded.loginAlert(vc: self) {
                        self.showCommentModal(for: post)
                    }
                })
                .disposed(by: sfCell.disposeBag)
                
                output.pushProfile
                    .asSignal(onErrorSignalWith: .empty()).emit(onNext: { [weak self] name in
                    guard let name, let self else { return }
                    let userPageVM = UserPageVM()
                    userPageVM.fetchUserInfo(userName: name)
                    
                    let userPageVC = UserPageVC(viewModel: userPageVM)
                    
                    self.navigationController?.navigationBar.prefersLargeTitles = false
                    self.navigationController?.pushViewController(userPageVC, animated: true)
                })
                    .disposed(by: sfCell.disposeBag)
            })
            .disposed(by: disposeBag)
    }

    
    private func setLayout() {
        view.overrideUserInterfaceStyle = .dark
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
        case .mainFeed, .filterPage:
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
        
        if user.uid == "KrDPnUeWkYOhQIRpaZb4uQ1Ma6l2" {
            actionSheet = deleteActionSheet(post: post)
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func deleteActionSheet(post: Post) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            guard let self else { return }
            let alert = Alert()
            alert.showAlert(from: self, title: "게시물 삭제", message: "삭제하시겠습니까?", includeCancel: true) { [weak self] in
                guard let self else { return }
                self.mainFeedVM.deletePost(uid: post.postUID)
                    .asSignal(onErrorSignalWith: .empty())
                    .emit(onNext: { _ in
                        alert.showAlert(from: self, title: "알림", message: "게시물이 삭제되었습니다.") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                    .disposed(by: self.disposeBag)
            }
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
    
    //MARK: - 차단하기 관련 메서드
    private func blockUser(authorUID: String) {
        guard !authorUID.isEmpty else {
            print("차단 실패: authorUID가 비어 있음")
            return
        }
        
        FirebaseManager.shared.addBlackList(blockedUser: authorUID) { [weak self] success in
            guard let self else { return }
            let alert = Alert()
            if success {
                print("차단 성공: \(authorUID)")
                alert.showAlert(from: self, title: "차단 완료", message: "")
            } else {
                print("차단 실패: \(authorUID)")
                alert.showAlert(from: self, title: "차단 실패", message: "차단을 실패했습니다. 다시 시도해주세요.")
            }
        }
    }
    
    func innerCollectionViewPlayers(playOrPause: Bool) {
        guard collectionView.numberOfItems(inSection: 0) > 0 else {
            print("현재 컬렉션 뷰의 아이템 수 0, 데이터가 로드 전.")
            return
        }
        
        let indexPath = IndexPath(item: currentPageIndex, section: 0)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? SFCollectionViewCell else {
            print("현재 페이지의 셀을 찾을 수 없음.")
            return
        }
        
        let innerCollectionView = cell.collectionView
        
        for feedCell in innerCollectionView.visibleCells {
            if let innerCell = feedCell as? SFFeedCell, let media = innerCell.media {
                //                print("내부 셀 미디어 URL: \(media.url)")
                
                if currentPageIndex == 0,
                   collectionView.numberOfItems(inSection: 0) == 0 {
                    print("첫번째 셀 실행")
                    //                    innerCell.playVideo(reStart: true)
                }
                
                if let url = URL(string: media.url) {
                    let fileExtension = url.pathExtension.lowercased()
                    
                    if fileExtension == "mp4" {
                        if playOrPause {
                            print("비디오 재생: \(media.url)")
                            innerCell.playVideo(reStart: true)
                        } else {
                            print("비디오 정지: \(media.url)")
                            innerCell.stopVideo()
                        }
                    } else {
                        print("비디오 파일이 아님: \(media.url)")
                        innerCell.stopVideo()
                    }
                }
            }
        }
    }
    
    func stopAllVideos() {
        for cell in collectionView.visibleCells {
            if let feedCell = cell as? SFCollectionViewCell {
                let innerCollectionView = feedCell.collectionView
                for innerCell in innerCollectionView.visibleCells {
                    if let feedCell = innerCell as? SFFeedCell, let media = feedCell.media {
                        print("비디오 정지: \(media.url)")
                        feedCell.stopVideo()
                    }
                }
            }
        }
    }
    
    func playVisibleVideo(reStart: Bool) {
        for cell in collectionView.visibleCells {
            if let feedCell = cell as? SFCollectionViewCell {
                let innerCollectionView = feedCell.collectionView
                for innerCell in innerCollectionView.visibleCells {
                    if let feedCell = innerCell as? SFFeedCell, let media = feedCell.media {
                        if reStart {
                            print("리스타트 비디오 재생: \(media.url)")
                            feedCell.playVideo(reStart: true)
                        } else {
                            print("리스타트 아닌 비디오 재생: \(media.url)")
                            feedCell.rePlay = true
                            feedCell.playVideo(reStart: false)
                            feedCell.rePlay = false
                        }
                    }
                }
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
                mainFeedVM.fetchInitialFeed()
                self.innerCollectionViewPlayers(playOrPause: true)
                isRefresh = true
            }
            self.stopAllVideos()
        }
        
        let pageIndex = Int(round(scrollView.contentOffset.y / scrollView.frame.height))
//        print("인덱스 확인 \(pageIndex)")
        guard currentPageIndex != pageIndex else { return }
        currentPageIndex = pageIndex
        print("인덱스 넘어감 \(currentPageIndex)")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        activityIndicator.stopAnimating()
        if feedType == .mainFeed {
            isRefresh = false
        }
        
        innerCollectionViewPlayers(playOrPause: true)
        print("위아래 스크롤 실행")
        
    }
}

extension SFMainFeedVC {
    func setupCollectionView() {
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
