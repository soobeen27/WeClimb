//
//  FeedVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class FeedVC: UIViewController {
    enum Section {
        case feed
    }
    let feedVM: FeedVM
    var coordinator: FeedChildCoordinator?
    
    private let container = AppDIContainer.shared
    
    let postType: PostType
    
    let disposeBag = DisposeBag()
    
    var onFinish: ((FeedPushType) -> Void)?
    
    private let fetchType: BehaviorRelay<PostFetchType?> = .init(value: .initial)
    private let addtionalButtonTapped = BehaviorRelay<(postItem: PostItem, isMine: Bool)?>(value: nil)
    private let selectedButtonType = PublishRelay<FeedMenuSelection>()

    private var feedMenuView = FeedMenuView()
    
    private let customAlert: DefaultAlertVC = {
        let alert = DefaultAlertVC(alertType: .title)
        alert.modalPresentationStyle = .overCurrentContext
        return alert
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, PostItem> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, PostItem>(collectionView: postCollectionView) { [weak self] collectionView, indexPath, item in
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionCell.className, for: indexPath) as? PostCollectionCell, let self
           else { return UICollectionViewCell() }
            let viewModel = self.container.resolve(PostCollectionCellVM.self)
            cell.configure(postItem: item, postCollectionCellVM: viewModel)
            
            cell.currentPost
                .asDriver()
                .drive(onNext: { [weak self] postItem in
                    guard let self, let postItem else { return }
                    self.onFinish?(.comment(postItem: postItem))
                })
                .disposed(by: cell.disposeBag)
            
            cell.additonalButtonTapped
                .bind(to: self.addtionalButtonTapped)
                .disposed(by: cell.disposeBag)
            
            cell.gymTapInfo.bind(onNext: { [weak self] gym, level, hold in
                guard let gym, let self else { return }
                self.onFinish?(.gym(gymName: gym, level: level, hold: hold))
            })
            .disposed(by: cell.disposeBag)
            
            cell.userTapInfo.bind(onNext: { [weak self] name in
                guard let self else { return }
                self.onFinish?(.user(userName: name))
            })
            .disposed(by: cell.disposeBag)
            
           return cell
        }
        return dataSource
    }()
    
    private lazy var postCollectionView: UICollectionView = {
        let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.height ?? 0
        let width = view.bounds.width
        let height = view.bounds.height - tabBarHeight
        let size = CGSize(width: width, height: height)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = FeedConsts.CollectionView.lineSpacing
        layout.itemSize = size
        
        let collectionView = UICollectionView(frame: CGRect(origin: .zero, size: size), collectionViewLayout: layout)
        collectionView.backgroundColor = FeedConsts.CollectionView.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(PostCollectionCell.self, forCellWithReuseIdentifier: PostCollectionCell.className)
        collectionView.delegate = self
        view.addSubview(collectionView)
        return collectionView
    }()
        
    init(viewModel: FeedVM, postType: PostType) {
        self.feedVM = viewModel
        self.postType = postType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindViewModel()
        bindMenu()
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        VideoManager.shared.stopVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VideoManager.shared.playCurrentVideo()
    }
    
    private func bindViewModel() {
        let input = FeedVMImpl.Input(postType: Observable.just(postType),
                                     fetchType: fetchType,
                                     additionalButtonTap: addtionalButtonTapped.asObservable(),
                                     additionalButtonTapType: selectedButtonType
        )
        let output = feedVM.transform(input: input)
            
        output.postItems.asDriver().drive(onNext: { [weak self] postItems in
                guard let self else { return }
                self.bindSnapshot(postItems: postItems)
            })
            .disposed(by: disposeBag)
        
        output.isMine
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isMine in
                guard let self else { return }
                if self.postCollectionView.isScrollEnabled {
                    self.presentMenu(isMine: isMine)
                } else {
                    self.dismissMenu()
                }
            })
            .disposed(by: disposeBag)
        
        if let startIndex = output.startIndex.value {
            scrollTo(startIndex: startIndex)
        }
    }
    
    private func scrollTo(startIndex: Int) {
        let startIndexPath = IndexPath(item: startIndex, section: 0)
        self.postCollectionView.scrollToItem(at: startIndexPath, at: .top, animated: false)
    }
    
    private func bindSnapshot(postItems: [PostItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PostItem>()
        snapshot.appendSections([.feed])
        snapshot.appendItems(postItems)
        dataSource.apply(snapshot, animatingDifferences: true)
        if let centerCell = findCenterCell(in: postCollectionView) {
            let mediaCollectionview = centerCell.mediaCollectionView
            VideoManager.shared.reset()
            if let mediaCenterCell = findMediaCenterCell(in:  mediaCollectionview) {
                mediaCenterCell.videoView.playVideo()
            }
        }
    }
    
    private func presentMenu(isMine: Bool) {
        let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.height ?? 0
        feedMenuView.isMine = isMine
        view.addSubview(feedMenuView)
        feedMenuView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-FeedConsts.Menu.Size.padding)
            $0.top.equalTo(view.snp.bottom).offset(-(FeedConsts.Menu.Constraint.bottom + tabBarHeight))
        }
        feedMenuView.alpha = 1
        postCollectionView.isScrollEnabled = false
    }
    
    private func dismissMenu() {
        feedMenuView.alpha = 0
        feedMenuView.removeFromSuperview()
        postCollectionView.isScrollEnabled = true
    }
    
    private func bindMenu() {
        feedMenuView.selectedButtonType
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] type in
                guard let self else { return }
                self.dismissMenu()
                self.presentAlert(type: type)
            })
            .disposed(by: disposeBag)
    }
        
    private func presentAlert(type: FeedMenuSelection) {
        var titleText: String = ""
        switch type {
        case .block: titleText = CommentConsts.Alert.alertBlockTitle
        case .delete: titleText = CommentConsts.Alert.alertDeleteTitle
        case .report: titleText = CommentConsts.Alert.alertReportTitle
        }
        self.customAlert.setTitle(titleText)
        self.present(self.customAlert, animated: false)
        self.customAlert.customAction = { [weak self] in
            guard let self else { return }
            self.selectedButtonType.accept(type)
        }
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.black
    }
    
    private func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension FeedVC: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self else { return }
            if let collectionView = scrollView as? UICollectionView {
                if let ceterCell = self.findCenterCell(in: collectionView) {
                    let mediaCollectionView = ceterCell.mediaCollectionView
                    if let mediaCenterCell = self.findMediaCenterCell(in: mediaCollectionView) {
                        mediaCenterCell.videoView.playVideo()
                    }
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        VideoManager.shared.reset()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        VideoManager.shared.reset()
        let contentOffset = scrollView.contentOffset
        let scrollViewHeight = collectionView.frame.size.height
        let scrollContentSizeHeight = collectionView.contentSize.height
        let scrollOffsetThreshold = scrollContentSizeHeight - scrollViewHeight
        
        if contentOffset.y >= scrollOffsetThreshold {
            if collectionView.indexPathsForVisibleItems.sorted().last != nil {
                fetchType.accept(.more)
            }
        }
        
        if collectionView.contentOffset.y < -100 {
            fetchType.accept(.initial)
        }
    }
    
    func findCenterCell(in collectionView: UICollectionView) -> PostCollectionCell? {
        let centerPoint = CGPoint(x: collectionView.bounds.midX + collectionView.contentOffset.x,
                                   y: collectionView.bounds.midY + collectionView.contentOffset.y)
        
        let visibleCells = collectionView.visibleCells.compactMap { $0 as? PostCollectionCell }
        
        var closestCell: PostCollectionCell?
        var minimumDistance: CGFloat = .greatestFiniteMagnitude
        
        for cell in visibleCells {
            if let indexPath = collectionView.indexPath(for: cell),
               let attributes = collectionView.layoutAttributesForItem(at: indexPath) {
                let cellCenter = attributes.center
                let distance = hypot(centerPoint.x - cellCenter.x, centerPoint.y - cellCenter.y)
                
                if distance < minimumDistance {
                    minimumDistance = distance
                    closestCell = cell
                }
            }
        }
        
        return closestCell
    }
    
    func findMediaCenterCell(in collectionView: UICollectionView) -> MediaCollectionCell? {
        let centerPoint = CGPoint(x: collectionView.bounds.midX + collectionView.contentOffset.x,
                                   y: collectionView.bounds.midY + collectionView.contentOffset.y)
        
        let visibleCells = collectionView.visibleCells.compactMap { $0 as? MediaCollectionCell }
        
        var closestCell: MediaCollectionCell?
        var minimumDistance: CGFloat = .greatestFiniteMagnitude
        
        for cell in visibleCells {
            if let indexPath = collectionView.indexPath(for: cell),
               let attributes = collectionView.layoutAttributesForItem(at: indexPath) {
                let cellCenter = attributes.center
                let distance = hypot(centerPoint.x - cellCenter.x, centerPoint.y - cellCenter.y)
                
                if distance < minimumDistance {
                    minimumDistance = distance
                    closestCell = cell
                }
            }
        }
        
        return closestCell
    }
}
