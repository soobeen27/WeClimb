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

struct PostItem: Hashable {
    let uid: String
}

class FeedVC: UIViewController {
    enum Section {
        case feed
    }
    let FeedVM: FeedVM
    var coordinator: FeedCoordinator?
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, PostItem> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, PostItem>(collectionView: postCollectionView) { collectionView, indexPath, item in
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionCell.className, for: indexPath) as? PostCollectionCell
           else {
               return UICollectionViewCell()
           }
           return cell
        }
        return dataSource
    }()
    
    private lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = FeedConts.CollectionView.lineSpacing
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = FeedConts.CollectionView.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PostCollectionCell.self, forCellWithReuseIdentifier: PostCollectionCell.className)
        view.addSubview(collectionView)
        return collectionView
    }()
    
    init(viewModel: FeedVM) {
        self.FeedVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.red
    }
}
