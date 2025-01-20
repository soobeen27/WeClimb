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
    
    private var user: User? {
        didSet {
            guard let user, let postItem else { return }
            configureProfileView(postItem: postItem, user: user)
        }
    }
    
    private var postItem: PostItem?
    
    private lazy var mediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = FeedConsts.CollectionView.lineSpacing
        layout.itemSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
        let collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionView.register(MediaCollectionCell.self, forCellWithReuseIdentifier: MediaCollectionCell.className)
        collectionView.showsHorizontalScrollIndicator = false
//        self.contentView.addSubview(collectionView)
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
    }
    
    func configure(postItem: PostItem) {
        self.postItem = postItem
        bindViewModel()
    }
    
    private func configureProfileView(postItem: PostItem, user: User) {
        profileView.configure(with: PostProfileModel(profileImage: user.profileImage, name: user.userName, gymName: postItem.gym, heightArmReach: "아직 없어용", level: .appleIcon, hold: .holdRed, caption: postItem.caption))
    }
    
    private func bindViewModel() {
        viewModel = container.resolve(PostCollectionCellVM.self)
        guard let viewModel, let postItem else { return }
        
        let output = viewModel.transform(input: PostCollectionCellVMImpl.Input(postItem: postItem, likeButtonTap: postSidebarView.likeButtonTap))
        
        output.user
            .map { user -> User in
                return user
            }
            .asDriver(onErrorJustReturn: User.erroredUser)
            .drive(onNext: { [weak self] user in
                guard let self else { return }
                self.user = user
            })
            .disposed(by: disposeBag)
        
        let isLike = output.isLike
        let likeCount = output.likes
        bindSidebarView(isLike: isLike, likeCount: likeCount)
        
        output.likeResult.subscribe(onSuccess: { likes in
            print(likes)
        }, onFailure: { error in
            print(error)
        })
        .disposed(by: disposeBag)
    }
    
    private func bindSidebarView(isLike: Bool?, likeCount: Int) {
        postSidebarView.isLikeRelay.accept(isLike)
        postSidebarView.likeCountRelay.accept(likeCount)
    }
    
    private func setLayout() {
        contentView.backgroundColor = .clear
        [profileView, postSidebarView]
            .forEach {
                contentView.addSubview($0)
            }
        profileView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        postSidebarView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(FeedConsts.PostCollectionCell.Size.sidebarBottom)
            $0.trailing.equalToSuperview().inset(FeedConsts.Profile.Size.padding)
        }
    }
    
}
