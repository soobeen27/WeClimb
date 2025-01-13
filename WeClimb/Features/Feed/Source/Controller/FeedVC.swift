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

//    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, PostItem> = {
//        let dataSource = UICollectionViewDiffableDataSource<Section, PostItem>(collectionView: postCollectionView) { collectionView, indexPath, item in
//           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionCell.className, for: indexPath) as? PostCollectionCell
//           else {
//               return UICollectionViewCell()
//           }
//           return cell
//        }
//        return dataSource
//    }()
//    
//    private lazy var postCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = FeedConsts.CollectionView.lineSpacing
//        
//        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
//        collectionView.backgroundColor = FeedConsts.CollectionView.backgroundColor
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.register(PostCollectionCell.self, forCellWithReuseIdentifier: PostCollectionCell.className)
//        view.addSubview(collectionView)
//        return collectionView
//    }()
    
    let profileView: PostProfileView = {
        let view = PostProfileView()
        view.profileImage = UIImage.logo
        view.name = "위클"
        view.heightArmReach = "180cm 212cm"
        view.gymName = "서울숲클라이밍 뚝섬점"
        view.level = UIImage.colorRed
        view.hold = UIImage.colorYellow
        view.caption = "안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요"
        return view
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
        feedVM.postItemRelay.subscribe(onNext: { item in
            item.forEach { postitem in
                print("fetch post test: \(postitem.postUID)")
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.black
        
        view.addSubview(profileView)
        
        profileView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
