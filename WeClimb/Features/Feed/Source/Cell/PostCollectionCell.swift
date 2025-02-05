//
//  PostCollectionCell.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import Swinject
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

import FirebaseFirestore

struct MediaItem: Hashable {
    let mediaUID: String
    let url: String
    let hold: String?
    let grade: String?
    let gym: String?
    let creationDate: Date?
    let postRef: String?
    let thumbnailURL: String?
    let height: Int?
    let armReach: Int?
    
    init(mediaUID: String, url: String, hold: String?, grade: String?, gym: String?, creationDate: Date?, postRef: DocumentReference?, thumbnailURL: String?, height: Int?, armReach: Int?) {
        self.mediaUID = mediaUID
        self.url = url
        self.hold = hold
        self.grade = grade
        self.gym = gym
        self.creationDate = creationDate
        self.postRef = postRef?.path
        self.thumbnailURL = thumbnailURL
        self.height = height
        self.armReach = armReach
    }
}

class PostCollectionCell: UICollectionViewCell {
    enum Section {
        case media
    }
    var disposeBag = DisposeBag()
    private let container = AppDIContainer.shared
    private var viewModel: PostCollectionCellVM?
    private let profileView = PostProfileView()
    private let postSidebarView = PostSidebarView()
    private let postPageControl = PostPageControl()
    
    private let currentMediaIndexRelay = BehaviorRelay<Int>.init(value: 0)
    private var totalMediaCountRelay = BehaviorRelay<Int>.init(value: 0)
    
    private var user: User? {
        didSet {
            guard let user, let postItem else { return }
            configureProfileView(postItem: postItem, user: user)
        }
    }
    var caption: String?
    
    private var postItem: PostItem?
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, MediaItem> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, MediaItem>(collectionView: mediaCollectionView)
        { [weak self] collectionView, indexPath, mediaItem in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionCell.className, for: indexPath) as? MediaCollectionCell, let self else {
                return UICollectionViewCell()
            }
            cell.configure(mediaItem: mediaItem)
            return cell
        }
        
        return dataSource
    }()
    
    lazy var mediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = FeedConsts.CollectionView.lineSpacing
        layout.itemSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
        let collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionView.register(MediaCollectionCell.self, forCellWithReuseIdentifier: MediaCollectionCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = FeedConsts.CollectionView.backgroundColor
        collectionView.delaysContentTouches = false
        collectionView.delegate = self
        self.contentView.addSubview(collectionView)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileView.resetToDefaultState()
        viewModel = nil
        disposeBag = DisposeBag()
        caption = nil
        mediaCollectionView.setContentOffset(.zero, animated: false)
    }
    
    func configure(postItem: PostItem, postCollectionCellVM: PostCollectionCellVM) {
        viewModel = postCollectionCellVM
        self.postItem = postItem
        bindViewModel()
        caption = postItem.caption
        bindMediaIndex()
        bindTotalPageCount()

    }
    
    private func configureProfileView(postItem: PostItem, user: User) {
        profileView.configure(with: PostProfileModel(profileImage: user.profileImage, name: user.userName, gymName: postItem.gym, heightArmReach: heightArmReach(height: user.height, armReach: user.armReach), level: .closeIcon, hold: .closeIcon, caption: postItem.caption))
    }
    
    private func bindViewModel() {
        guard let viewModel, let postItem else { return }
                
        let output = viewModel.transform(input: PostCollectionCellVMImpl.Input(postItem: postItem, likeButtonTap: postSidebarView.likeButtonTap, currentMediaIndex: currentMediaIndexRelay))
        
        output.user
            .map { user -> User in
                return user
            }
            .asDriver(onErrorJustReturn: User.erroredUser)
            .drive(onNext: { [weak self] (user: User) in
                guard let self else { return }
                self.user = user
            })
            .disposed(by: disposeBag)
        
        output.isLike
            .bind(to: postSidebarView.isLikeRelay)
            .disposed(by: disposeBag)
        output.likeCount
            .bind(to: postSidebarView.likeCountRelay)
            .disposed(by: disposeBag)

        output.mediaItems
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] mediaItems in
            guard let self else { return }
                self.totalMediaCountRelay.accept(mediaItems.count)
                self.bindSnapShot(mediaItems: mediaItems)
        }).disposed(by: disposeBag)
        
        output.levelHoldImages
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] levelHold in
                guard let level = levelHold.level, let hold = levelHold.hold else { return }
                self?.profileView.updateHoldLevel(hold: hold, level: level)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSnapShot(mediaItems: [MediaItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MediaItem>()
        snapshot.appendSections([.media])
        snapshot.appendItems(mediaItems)
        if mediaItems.count == 1 {
            self.mediaCollectionView.isScrollEnabled = false
        } else {
            self.mediaCollectionView.isScrollEnabled = true
        }
        self.dataSource.apply(snapshot, animatingDifferences: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self else { return }
            
            if let centerCell = findCenterCell(in: self.mediaCollectionView),
               let indexPathRow = self.indexPathFrom(collectionView: self.mediaCollectionView, cell: centerCell)?.row {
                centerCell.videoView.playVideo()
                self.currentMediaIndexRelay.accept(indexPathRow)
            }
        }
    }
    
    private func heightArmReach(height: Int?, armReach: Int?) -> String {
        if let height, let armReach {
            return "\(height)cmㆍ\(armReach)cm"
        } else if let height {
            return "\(height)cm"
        }
        return "정보가 없어용"
    }
    
    private func bindSidebarView(isLike: Bool?, likeCount: Int) {
        postSidebarView.isLikeRelay.accept(isLike)
        postSidebarView.likeCountRelay.accept(likeCount)
    }
    
    private func bindMediaIndex() {
        currentMediaIndexRelay
            .asDriver()
            .drive(onNext: { [weak self] index in
                self?.postPageControl.currentPageCount = index + 1
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTotalPageCount() {
        totalMediaCountRelay
            .asDriver()
            .drive(onNext: { [weak self] count in
                self?.postPageControl.totalPageCount = count
            })
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        contentView.backgroundColor = .clear
        [profileView, postSidebarView, postPageControl]
            .forEach {
                self.addSubview($0)
            }
        
        profileView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        postSidebarView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(FeedConsts.PostCollectionCell.Size.sidebarBottom)
            $0.trailing.equalToSuperview().inset(FeedConsts.Profile.Size.padding)
        }
        
        postPageControl.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(FeedConsts.pageControl.Size.top)
            $0.trailing.equalToSuperview().offset(-FeedConsts.pageControl.Size.trailing)
        }
    }
}

extension PostCollectionCell: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self else { return }
            if let collectionView = scrollView as? UICollectionView,
               let centerCell = findCenterCell(in: collectionView),
               let indexPathRow = self.indexPathFrom(collectionView: collectionView, cell: centerCell)?.row {
                centerCell.videoView.playVideo()
                self.currentMediaIndexRelay.accept(indexPathRow)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        VideoManager.shared.reset()
    }
    
    private func findCenterCell(in collectionView: UICollectionView) -> MediaCollectionCell? {
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
    
    private func indexPathFrom(collectionView: UICollectionView, cell: MediaCollectionCell) -> IndexPath? {
        return collectionView.indexPath(for: cell)
    }
}
