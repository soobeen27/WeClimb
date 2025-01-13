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
        view.caption = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."
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
