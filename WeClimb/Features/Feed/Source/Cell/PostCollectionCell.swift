//
//  PostCollectionCell.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

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
    
    private let profileView = PostProfileView()
    
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
        configureProfileView(postItem: postItem)
    }
    
    private func configureProfileView(postItem: PostItem) {
        profileView.configure(with: PostProfileModel(profileImage: .appleIcon, name: postItem.authorUID, gymName: postItem.gym, heightArmReach: "아직 없어용", level: .appleIcon, hold: .holdRed, caption: postItem.caption))
    }
    
    private func setLayout() {
        contentView.backgroundColor = .clear
        contentView.addSubview(profileView)
        profileView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
}
