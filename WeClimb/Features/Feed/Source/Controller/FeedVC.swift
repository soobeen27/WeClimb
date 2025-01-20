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
    
    let disposeBag = DisposeBag()
    
    private let fetchType: BehaviorRelay<FetchPostType> = .init(value: .initial)

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, PostItem> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, PostItem>(collectionView: postCollectionView) { collectionView, indexPath, item in
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionCell.className, for: indexPath) as? PostCollectionCell
           else { return UICollectionViewCell() }
            cell.configure(postItem: item)
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
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.black
    }
    
    private func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
