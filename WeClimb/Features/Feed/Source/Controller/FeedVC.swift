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
    var coordinator: FeedCoordinator?
    
    private let container = AppDIContainer.shared
    
    let disposeBag = DisposeBag()
    
    private let fetchType: BehaviorRelay<FetchPostType> = .init(value: .initial)

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, PostItem> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, PostItem>(collectionView: postCollectionView) { [weak self] collectionView, indexPath, item in
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionCell.className, for: indexPath) as? PostCollectionCell, let self
           else { return UICollectionViewCell() }
            let viewModel = self.container.resolve(PostCollectionCellVM.self)
            cell.configure(postItem: item, postCollectionCellVM: viewModel)
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
        
    init(viewModel: FeedVM) {
        self.feedVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindViewModel()
        hideNavigationBar()
    }
    
    private func bindViewModel() {
        let input = FeedVMImpl.Input(fetchType: fetchType)
        feedVM.transform(input: input)
            .postItems.asDriver().drive(onNext: { [weak self] postItems in
                guard let self else { return }
                self.bindSnapshot(postItems: postItems)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSnapshot(postItems: [PostItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PostItem>()
        snapshot.appendSections([.feed])
        snapshot.appendItems(postItems)
        dataSource.apply(snapshot, animatingDifferences: true)
        if let centerCell = findCenterCell(in: postCollectionView) {
            let mediaCollectionview = centerCell.mediaCollectionView
//            mediaCollectionview.visibleCells.compactMap{ $0 as? MediaCollectionCell }.forEach {
//                VideoManager.shared.reset()
//            }
            VideoManager.shared.reset()
            if let mediaCenterCell = findMediaCenterCell(in:  mediaCollectionview) {
                mediaCenterCell.videoView.playVideo()
            }
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
        let contentOffset = scrollView.contentOffset
        let scrollViewHeight = collectionView.frame.size.height
        let scrollContentSizeHeight = collectionView.contentSize.height
        let scrollOffsetThreshold = scrollContentSizeHeight - scrollViewHeight
        
        if contentOffset.y >= scrollOffsetThreshold {
            if collectionView.indexPathsForVisibleItems.sorted().last != nil {
                fetchType.accept(.more)
            }
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
