//
//  UserPageVC.swift
//  WeClimb
//
//  Created by 강유정 on 8/28/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class UserPageVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: UserPageVM // 외부에서 주입받기
    
    private var isFollowing = false
    
    // 값이 계속 변동하기 때문에 var로함 - DS
    var userUID: String?
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "testStone")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        //        label.text = "qockqock"
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        return label
    }()
    
    // 추후 추가예정
    private let levelLabel: UILabel = {
        let label = UILabel()
        //        label.text = "V4"
        label.backgroundColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    // 아직 연동안됨
    private let infoLabel: UILabel = {
        let label = UILabel()
        //        label.text = "체형: 183cm | 185cm"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private let followFollowingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(UserPageNameSpace.following, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let followCountLabel: UILabel = {
        let label = UILabel()
        label.text = "654"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let followingCountLabel: UILabel = {
        let label = UILabel()
        label.text = "321"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let followLabel: UILabel = {
        let label = UILabel()
        label.text = UserPageNameSpace.follow
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = UserPageNameSpace.following
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 32
        stackView.alignment = .center
        return stackView
    }()
    
    private let followStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private let followingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private let segmentControl: UISegmentedControl = {
        // 추후 하나 생성예정
        //        let segmentControl = UISegmentedControl(items: [UIImage(systemName: "square.grid.2x2") ?? UIImage(), UserPageNameSpace.none])
        let segmentControl = UISegmentedControl(items: [UIImage(systemName: "square.grid.2x2") ?? UIImage()])
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        // 셀 사이의 스페이싱 설정
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        
        let width = (UIScreen.main.bounds.width - 2 * 16 - 2 * 1.0) / 3 // 전체 화면 - 양옆 여백 - 셀끼리의 스페이싱 / 3
        layout.itemSize = CGSize(width: width, height: width)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyPageCell.self, forCellWithReuseIdentifier: MyPageCell.className)
        collectionView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        return collectionView
    }()
    
    private let emptyPost: UIView = {
        let view = UIView()
        view.isHidden = false
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "no_Post") // 비어 있을 때 보여줄 이미지
        
        let label = UILabel()
        label.text = "게시물이 없습니다."
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        
        [imageView, label]
            .forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.height.equalTo(120)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        return view
    }()
    
    init(viewModel: UserPageVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        setLayout()
        bind()
        setNavigation()
        bindPost()
        bindCollectionView()
        bindEmpty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .label
    }
    
    func configure(with data: User) {
        nameLabel.text = data.userName

//            levelLabel.text = data.userRole
//            infoLabel.text = "체형: \(data.height ?? "정보 없음") | 팔길이: \(data.armReach ?? "정보 없음")"
        
        // 이미지 로드 (Kingfisher 사용)
        if let profileImageURL = data.profileImage {
            FirebaseManager.shared.loadImage(from: profileImageURL, into: profileImage)
        } else {
            profileImage.image = UIImage(named: "testStone")
        }
    }
    
    func setNavigation() {
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(self.rightBarButtonTapped)
        )
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    //MARK: - 신고하기, 차단 버튼 YJ
    @objc private func rightBarButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            self?.reportModal()
        }
        let deleteAction = UIAlertAction(title: "차단하기", style: .destructive) { [weak self] _ in
            self?.blackList()
        }
        
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
    
    //MARK: - 차단하기 기능
    private func blackList() {
        guard let userUID = userUID else {
            print("차단할 유저 UID가 없습니다.")
            return
        }
        
        print("차단할 유저 UID: \(userUID)")
        
        // 차단 기능 수행
        viewModel.blockUser(byUID: userUID) { [weak self] success in
            guard let self = self else { return }
            if success {
                print("차단 완료!")
                CommonManager.shared.showAlert(from: self, title: "차단완료", message: "")
            } else {
                print("차단 실패")
                CommonManager.shared.showAlert(from: self, title: "차단실패", message: "")
            }
        }
    }

    
    private func buttonTapped() {
        isFollowing.toggle()
        
        if isFollowing {
            followFollowingButton.setTitle(UserPageNameSpace.follow, for: .normal)
            followFollowingButton.backgroundColor = .systemGray6
            followFollowingButton.setTitleColor(.black, for: .normal)
        } else {
            followFollowingButton.setTitle(UserPageNameSpace.following, for: .normal)
            followFollowingButton.backgroundColor = .systemBlue
            followFollowingButton.setTitleColor(.white, for: .normal)
        }
    }

    private func setLayout() {
        [profileImage, profileStackView, totalStackView, segmentControl, collectionView, emptyPost]
            .forEach{ view.addSubview($0) }
        
        [nameStackView, infoLabel, followFollowingButton]
            .forEach{ profileStackView.addArrangedSubview($0) }
        
        [nameLabel, levelLabel]
            .forEach{ nameStackView.addArrangedSubview($0) }
        
        [followCountLabel, followLabel]
            .forEach{ followStackView.addArrangedSubview($0) }
        
        [followingCountLabel, followingLabel]
            .forEach{ followingStackView.addArrangedSubview($0) }
        
        [followStackView, followingStackView]
            .forEach{ totalStackView.addArrangedSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(80)
        }
        
        profileStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
            $0.centerY.equalTo(profileImage.snp.centerY)
            $0.height.equalTo(80)
        }
        
        followFollowingButton.snp.makeConstraints {
            $0.width.equalTo(120)
        }
        
        totalStackView.snp.makeConstraints {
            $0.leading.equalTo(profileStackView.snp.trailing).offset(32)
            $0.centerY.equalTo(profileImage.snp.centerY)
            $0.height.equalTo(80)
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        emptyPost.snp.makeConstraints {
            $0.centerX.equalTo(collectionView.snp.centerX)
            $0.centerY.equalTo(collectionView.snp.centerY).offset(-20)
        }
    }
    
    private func bind() {
        viewModel.userData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                // 옵셔널 타입인 user를 언래핑
                guard let self, let user = user else { return }
                self.configure(with: user)
            })
            .disposed(by: disposeBag)
        
        followFollowingButton.rx.tap
            .bind { [weak self] in
                print("followFollowingButton tapped")
                self?.buttonTapped()
            }
            .disposed(by: disposeBag)
    }
    

    private func bindPost() {
        viewModel.posts
            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: MyPageCell.className, cellType: MyPageCell.self)) { index, post, cell in

                if let thumbnailURL = post.thumbnail, !thumbnailURL.isEmpty {
                    print("유저페이지 썸네일 URL: \(thumbnailURL)")
                    cell.configure(with: thumbnailURL)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindEmpty() {
        viewModel.posts
            .asDriver()
            .drive(onNext: { [weak self] posts in
                guard let self = self else { return }
                if posts.isEmpty {
                    self.emptyPost.isHidden = false
                    self.collectionView.isHidden = true
                } else {
                    self.emptyPost.isHidden = true
                    self.collectionView.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        collectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }

                let selectedIndex = indexPath.row
                let allPosts = self.viewModel.posts.value

                let mainFeedVM = MainFeedVM(shouldFetch: false)

                mainFeedVM.posts.accept(allPosts)

                let mainFeedVC = SFMainFeedVC()
                mainFeedVC.viewModel = mainFeedVM

                mainFeedVC.startingIndex = selectedIndex
                print("전달할 인데스: \(mainFeedVC.startingIndex)")

                self.navigationController?.pushViewController(mainFeedVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
//    private func bindPost() {
//        viewModel.userMediaPosts
//            .observe(on: MainScheduler.instance)
//            .bind(to: collectionView.rx.items(cellIdentifier: MyPageCell.className, cellType: MyPageCell.self)) { index, mediaPost, cell in
//
//                if let thumbnailURL = mediaPost.thumbnailURL, !thumbnailURL.isEmpty {
//                    print("유저페이지 썸네일 URL: \(thumbnailURL)")
//                    cell.configure(with: thumbnailURL)
//                } else {
//                    print("썸네일이 없습니다.")
//                    if let firstMediaURL = mediaPost.media.first?.url {
//                        print("첫 번째 이미지 URL: \(firstMediaURL)")
//                        cell.configure(with: firstMediaURL)
//                    } else {
//                        print("미디어가 없습니다.")
//                    }
//                }
//            }
//            .disposed(by: disposeBag)
//    }
    
//    private func bindEmpty() {
//        viewModel.userMediaPosts
//            .subscribe(onNext: { [weak self] posts in
//                guard let self = self else { return }
//                
//                DispatchQueue.main.async {
//                    if posts.isEmpty {
//                        self.emptyPost.isHidden = false
//                        self.collectionView.isHidden = true
//                    } else {
//                        self.emptyPost.isHidden = true
//                        self.collectionView.isHidden = false
//                    }
//                }
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    private func bindCollectionView() {
//        collectionView.rx.itemSelected
//            .subscribe(onNext: { [weak self] indexPath in
//                guard let self = self else { return }
//                
//                let selectedIndex = indexPath.row
//                let allPosts = self.viewModel.userMediaPosts.value
//                
//                let mainFeedVM = MainFeedVM(shouldFetch: false)
//                
//                let userAll = allPosts.map { ($0.post, $0.media) }
//                mainFeedVM.posts.accept(userAll)
//                
//                let mainFeedVC = SFMainFeedVC()
//                mainFeedVC.viewModel = mainFeedVM
//                
//                mainFeedVC.startingIndex = selectedIndex // 선택된 인덱스에서 스크롤 위치 설정
//                print("전달할 인데스: \(mainFeedVC.startingIndex)")
//                
//                self.navigationController?.pushViewController(mainFeedVC, animated: true)
//            })
//            .disposed(by: disposeBag)
//    }
}

