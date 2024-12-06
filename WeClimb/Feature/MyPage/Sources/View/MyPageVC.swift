//
//  MyPageVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

import RxSwift
import RxCocoa
//import RxGesture
import SnapKit

class MyPageVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MyPageVM()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "testStone") // 기본 프로필 이미지
        imageView.isUserInteractionEnabled = true // 사용자 입력 허용
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "WeClimber"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.text = "V6"
        label.backgroundColor = .purple
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private let userInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(MypageNameSpace.edit, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let followCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let followingCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let postCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let followLabel: UILabel = {
        let label = UILabel()
        label.text = MypageNameSpace.follow
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = MypageNameSpace.following
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let postLabel: UILabel = {
        let label = UILabel()
        label.text = MypageNameSpace.post
        label.font = UIFont.systemFont(ofSize: 13)
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
        stackView.spacing = 25
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 10
        //        stackView.backgroundColor = .mainPurple.withAlphaComponent(0.1)
        stackView.layer.borderColor = UIColor.systemGray4.cgColor
        stackView.layer.borderWidth = 0.5
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
    
    private let postStackView: UIStackView = {
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
    
    var uploadVC: UploadVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setNavigation()
        //        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        bindPost()
        bindEmpty()
        bindCollectionView()
        bindEditProfile()
        bindGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .label
        updateUserInfo()
        viewModel.loadUserMediaPosts()
    }
    
    
    // MARK: - 파이어베이스에 저장된 유저 정보 업데이트
    private func updateUserInfo() {
        FirebaseManager.shared.currentUserInfo { [weak self] (result: Result<User, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.nameLabel.text = user.userName
                    self?.userInfoLabel.text = "\(user.height ?? 0)cm  |  \(user.armReach ?? 0)cm"
                    
                    // Firebase Storage에서 이미지 로드
                    if let profileImageUrl = user.profileImage, let url = URL(string: profileImageUrl) {
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            if let error = error {
                                print("이미지를 로드하는 데 실패했습니다: \(error.localizedDescription)")
                                return
                            }
                            
                            // 데이터가 유효한지 확인 후, UIImage로 변환
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self?.profileImage.image = image
                                }
                            } else {
                                print("이미지 데이터가 유효하지 않습니다.")
                            }
                        }.resume()
                    } else {
                        print("프로필 이미지 URL이 없습니다.")
                    }
                    
                case .failure(let error):
                    print("현재 유저 정보 가져오기 실패: \(error)")
                }
            }
        }
    }
    
    
    // MARK: - 설정 버튼 YJ
    private func setNavigation() {
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(self.rightBarButtonTapped)
        )
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func rightBarButtonTapped() {
        let loginTypeDataSource = LoginTypeDataSourceImpl()

        let settingViewModel = SettingViewModelImpl(
            logoutUseCase: LogoutUseCaseImpl(),
            deleteUserUseCase: DeleteAccountUseCaseImpl(),
//            reAuthUseCase: ReAuthUseCaseImpl(),
            webNavigationUseCase: WebPageOpenUseCaseImpl(),
            loginRepository: LoginRepositoryImpl(loginTypeDataSource: loginTypeDataSource)
        )
        

        let settingsVC = SettingVC(viewModel: settingViewModel)
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    //MARK: - 레이아웃
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        collectionView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        
        [profileImage, profileStackView, /*totalStackView, */collectionView, segmentControl, emptyPost]
            .forEach{ view.addSubview($0) }
        
        [nameStackView, userInfoLabel, editButton]
            .forEach{ profileStackView.addArrangedSubview($0) }
        
        [nameLabel, /*levelLabel*/]
            .forEach{ nameStackView.addArrangedSubview($0) }
        
        [followCountLabel, followLabel]
            .forEach{ followStackView.addArrangedSubview($0) }
        
        [followingCountLabel, followingLabel]
            .forEach{ followingStackView.addArrangedSubview($0) }
        
        [postCountLabel, postLabel]
            .forEach{ postStackView.addArrangedSubview($0) }
        
//        [postStackView, followStackView, followingStackView]
//            .forEach{ totalStackView.addArrangedSubview($0) }
        
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
        
        editButton.snp.makeConstraints {
//            $0.top.equalTo(totalStackView.snp.bottom).offset(30)
//            //            $0.centerX.equalTo(totalStackView.snp.centerX)
//            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(120)
        }
        
//        totalStackView.snp.makeConstraints {
//            $0.top.equalTo(profileImage.snp.bottom).offset(30)
//            $0.leading.equalToSuperview().inset(16)
//            $0.trailing.equalToSuperview().inset(16)
//            $0.height.equalTo(60)
//        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        emptyPost.snp.makeConstraints {
            $0.centerX.equalTo(collectionView.snp.centerX)
            $0.centerY.equalTo(collectionView.snp.centerY).offset(-30)
        }
    }
    
    
    //MARK: - 바인드
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

//                let mainFeedVM = MainFeedVM(shouldFetch: false)
                let mainFeedVM = MainFeedVM()

                mainFeedVM.posts.accept(allPosts)

                let mainFeedVC = SFMainFeedVC(viewModel: mainFeedVM, startingIndex: selectedIndex, feedType: .myPage)
//                mainFeedVC.viewModel = mainFeedVM
//                mainFeedVC.startingIndex = selectedIndex
//                print("전달할 인데스: \(mainFeedVC.startingIndex)")

                self.navigationController?.pushViewController(mainFeedVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
//    private func bindPost() {
//        viewModel.userMediaPosts
//            .observe(on: MainScheduler.instance)
//            .do(onNext: { [weak self] post in
//                self?.postCountLabel.text = "\(post.count)"
//            })
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
//    
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
    
    private func bindEditProfile() {
        editButton.rx.tap
          .asSignal()
          .emit(onNext: { [weak self] in
            let editPageVC = EditPageVC()
            self?.navigationController?.pushViewController(editPageVC, animated: true)
          })
          .disposed(by: disposeBag)
      }
    
//    private func bindGesture() {
//        profileImage.rx.tapGesture()
//            .when(.recognized)
//            .subscribe(onNext: { [weak self] _ in
//                guard let self = self,
//                      let image = self.profileImage.image else { return }
//                self.presentFullscreenImage(image)
//            })
//            .disposed(by: disposeBag)
//    }
    
    private func bindGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true // 제스처를 사용하기 위해 필요
    }

    @objc 
    private func profileImageTapped() {
        guard let image = profileImage.image else { return }
        presentFullscreenImage(image)
    }
    
    private func presentFullscreenImage(_ image: UIImage) {
        let profileImageFullScreen = ProfileImageFullScreen(image: image)
        profileImageFullScreen.modalPresentationStyle = .overFullScreen
        profileImageFullScreen.modalTransitionStyle = .crossDissolve
        present(profileImageFullScreen, animated: true, completion: nil)
    }
}

//extension MyPageVC: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let modalVC = MyPageModalVC()
//        modalVC.modalPresentationStyle = .pageSheet
//
//        if let sheet = modalVC.sheetPresentationController {
//            let customDetent = UISheetPresentationController.Detent.custom { context in
//                return context.maximumDetentValue * 0.9
//            }
//            sheet.detents = [customDetent]
//            sheet.preferredCornerRadius = 20
//        }
//
//        present(modalVC, animated: true, completion: nil)
//    }
//}

