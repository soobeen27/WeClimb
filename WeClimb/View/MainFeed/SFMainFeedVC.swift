//
//  MainFeedVC_SF.swift
//  WeClimb
//
//  Created by 김솔비 on 9/5/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class SFMainFeedVC: UIViewController{
    
    private let disposeBag = DisposeBag()
    var viewModel = MainFeedVM(shouldFetch: true)
    var isRefresh = false
    var startingIndex: Int = 0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0  //셀간 여백 조정(효과없음)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(hex: "#0B1013")
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout) //레이아웃을 반환
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
    }
    
    //MARK: - 네비게이션바, 탭바 세팅
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(self.rightButtonTapped)
        )
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func rightButtonTapped() {
        actionSheet()
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
    
    private func bindCollectionView() {
        viewModel.posts
            .bind(to: collectionView.rx
                .items(cellIdentifier: SFCollectionViewCell.className,
                       cellType: SFCollectionViewCell.self)) { index, post, cell in
                
                cell.configure(with: post.post, media: post.media)
                cell.commentButton.rx.tap
                    .bind { [weak self] in
                        guard let self else { return }
                        self.showCommentModal(for: post.post)
                    }
                    .disposed(by: cell.disposeBag)
            }
                       .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected((post: Post, media: [Media]).self)
            .subscribe(onNext: { [weak self] post in
                self?.showCommentModal(for: post.post)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionViewScrollEvent() {
        collectionView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                guard let self else { return }
                
                let scrollViewHeight = self.collectionView.frame.size.height
                let scrollContentSizeHeight = self.collectionView.contentSize.height
                let scrollOffsetThreshold = scrollContentSizeHeight - scrollViewHeight
                
                // 스크롤이 마지막 셀에 도달했는지 확인
                if contentOffset.y >= scrollOffsetThreshold {
                    //                        if let indexPaths = self.collectionView.indexPathsForVisibleItems.sorted(),
                    if let lastIndexPath = self.collectionView.indexPathsForVisibleItems.sorted().last {
                        let isLastItem = lastIndexPath.item == (self.viewModel.posts.value.count - 1)
                        
                        if isLastItem && !self.viewModel.isLastCell {
                            self.viewModel.isLastCell = true
                            if self.viewModel.shouldFetch {
                                self.onLastCellReached()
                            }
                        }
                    }
                } else {
                    // 스크롤이 마지막 셀에 도달하지 않으면 플래그를 리셋
                    self.viewModel.isLastCell = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    // 마지막 셀 도달 시 처리할 이벤트 함수
    func onLastCellReached() {
        print("마지막 셀에 도달!")
        // 필요한 작업을 여기에 추가하세요
        viewModel.fetchMoreFeed()
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
    private func actionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            self?.reportModal()
        }
        let deleteAction = UIAlertAction(title: "차단하기", style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [reportAction, deleteAction, cancelAction]
            .forEach {
                actionSheet.addAction($0)
            }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - 신고하기 모달 시트
    private func reportModal() {
        let modalVC = FeedReportModalVC()
        presentModal(modalVC: modalVC)
    }
    
    //MARK: - 댓글 모달 시트
    private func commentModal() {
        let modalVC = FeedCommentModalVC()
        presentModal(modalVC: modalVC)
    }
    // MARK: - 신고하기 및 댓글 모달 표시
    private func showActionSheet(for post: Post) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            self?.reportModal()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [reportAction, cancelAction].forEach {
            actionSheet.addAction($0)
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showCommentModal(for post: Post) {
        //        let modalVC = FeedCommentModalVC()
        //        presentModal(modalVC: modalVC)
        print("기능없음")
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
                if !isRefresh && viewModel.shouldFetch {
                    viewModel.fetchInitialFeed()
                    isRefresh = true
                }
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            activityIndicator.stopAnimating()
            isRefresh = false
        }
        
    }

extension SFMainFeedVC {
    func setupCollectionView() {
        collectionView.reloadData()
        
        if !viewModel.shouldFetch {
            DispatchQueue.main.async {
                self.collectionView.isPagingEnabled = false
                let startingIndexPath = IndexPath(row: self.startingIndex, section: 0)
                self.collectionView.scrollToItem(at: startingIndexPath, at: .top, animated: false)
                self.collectionView.isPagingEnabled = true
            }
        }
    }
}

