//
//  SFCollectionViewCell.swift
//  WeClimb
//
//  Created by 김솔비 on 9/5/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import Kingfisher
import FirebaseAuth

class SFCollectionViewCell: UICollectionViewCell {
    
    private var likeViewModel: LikeViewModel?
    var disposeBag = DisposeBag()
    private var viewModel: MainFeedVM?
    var medias: [Media]?
    var post: Post?
    
    let pauseVide: ((SFFeedCell) -> Void)? = nil
    
    //MARK: - UI 세팅
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //가로 스크롤
        layout.itemSize = CGSize(width: contentView.bounds.width, height: UIScreen.main.bounds.width * (16.0/9.0))
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(hex: "#0B1013")
        collectionView.showsHorizontalScrollIndicator = false //스크롤바 숨김 옵션
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SFFeedCell.self, forCellWithReuseIdentifier: SFFeedCell.className)
        return collectionView
    }()
    
    private let reportDeleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let profileTapGesture = UITapGestureRecognizer()
    
    var profileTap: Driver<String?> {
        return profileTapGesture.rx.event
            .map { [weak self] _ in
//                self?.post?.authorUID
                self?.feedUserNameLabel.text
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var reportDeleteButtonTap: Driver<Post?> {
        print("rdbutton clicked")
        return reportDeleteButton.rx.tap
            .map { [weak self] in
                self?.post
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var commentButtonTap: Driver<Post?> {
        print("comment button tapped")
        return commentButton.rx.tap
            .map { [weak self] in
                self?.post
            }
            .asDriver(onErrorDriveWith: .empty())
    }

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        //        pageControl.numberOfPages = images.count
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    private let feedCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let feedUserProfileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.systemGray3.cgColor
        return image
    }()
    
    private let feedUserNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    // 피드 이미지
    private let feedImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let feedProfileAddressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    // 팔로우 버튼 임시 히든
//    private let followButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Follow", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//        button.layer.cornerRadius = 5
//        button.layer.borderWidth = 0.5
//        button.layer.borderColor = UIColor.systemGray3.cgColor
//        button.isHidden = true
//        return button
//    }()
    
//    private let levelLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.backgroundColor = .mainPurple.withAlphaComponent(0.5)
//        label.clipsToBounds = true
//        return label
//    }()
    
//    private let sectorLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = UIColor.white.withAlphaComponent(0.2)
//        return label
//    }()
//    
//    private let dDayLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = UIColor.white.withAlphaComponent(0.2)
//        return label
//    }()
    
    private let likeButton = UIButton()
    
    private let likeButtonCounter: UILabel = {
        let label = UILabel()
        label.text = FeedNameSpace.likeCount
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let commentButtonCounter: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let feedProfileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
//    private let gymInfoStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.spacing = 15
//        return stackView
//    }()
    
    private let likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()
    
    private let commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()
    
    
    // MARK: - 초기화 및 레이아웃 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setLayout()
//        setLikeButton()
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        likeViewModel = nil
        feedUserNameLabel.text = nil
        feedProfileAddressLabel.text = nil
        feedCaptionLabel.text = nil
        //        likeButtonCounter.text = nil
        likeButtonCounter.text = "0"
        feedUserProfileImage.image = nil
        pageControl.currentPage = 0
        post = nil
        medias = nil
        setLikeButton()
    }
    
    private func addGesture() {
        feedProfileStackView.addGestureRecognizer(profileTapGesture)
    }

    // MARK: - UI 구성
    private func setupUI() {
//        [
//            feedUserNameLabel, likeButton,
//            commentButton, followButton,
//            likeButtonCounter, commentButtonCounter,
//            reportDeleteButton
//        ]
//            .forEach { view in
//                addShadow(to: view)
//            }
        [
            feedUserNameLabel, likeButton,
            commentButton, likeButtonCounter,
            commentButtonCounter, reportDeleteButton
        ]
            .forEach { view in
                addShadow(to: view)
            }
        
        self.backgroundColor = UIColor(hex: "#0C1014")
//        [
//            collectionView, feedProfileStackView,
//            followButton, likeStackView,
//            commentStackView, feedCaptionLabel,
//            reportDeleteButton
//        ]
//            .forEach {
//                self.addSubview($0)
//            }
        [
            collectionView, feedProfileStackView,
            likeStackView, commentStackView,
            feedCaptionLabel, reportDeleteButton
        ]
            .forEach {
                self.addSubview($0)
            }
        //        [collectionView, feedProfileStackView, feedCaptionLabel]
        //            .forEach {
        //                self.addSubview($0)
        //            }
        [feedUserProfileImage, feedUserNameLabel]
            .forEach {
                feedProfileStackView.addArrangedSubview($0)
            }
        [likeButton, likeButtonCounter]
            .forEach {
                likeStackView.addArrangedSubview($0)
            }
        [commentButton, commentButtonCounter]
            .forEach {
                commentStackView.addArrangedSubview($0)
            }
//        [levelLabel, sectorLabel, dDayLabel]
//            .forEach {
//                gymInfoStackView.addArrangedSubview($0)
//                $0.font = .systemFont(ofSize: 13)
//                $0.textColor = .white
//                $0.textAlignment = .center
//                $0.layer.cornerRadius = 5
//                $0.layer.borderWidth = 0.5
//                $0.layer.borderColor = UIColor.systemGray5.cgColor
//                $0.layer.opacity = 0.8
//                $0.layer.masksToBounds = true
//            }
    }
    func pauseVideo(cell: SFFeedCell) {
        cell.player?.pause() // 비디오 정지
    }
    
    
    // MARK: - 레이아웃 설정
    private func setLayout() {
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
//            $0.height.equalTo(collectionView.snp.width).multipliedBy(16.0/9.0)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        feedProfileStackView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.76)
            $0.leading.equalToSuperview().inset(16)
        }
        feedUserProfileImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        feedUserNameLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 200, height: 40))
        }
//        followButton.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 50, height: 20))
//            $0.centerY.equalTo(feedProfileStackView.snp.centerY)
//            $0.leading.equalTo(feedProfileStackView.snp.trailing)
//        }
        feedCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(feedProfileStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
            $0.bottom.equalToSuperview().offset(-16)
        }
//        gymInfoStackView.snp.makeConstraints {
//            $0.top.equalTo(feedCaptionLabel.snp.bottom).offset(12)
//            $0.leading.equalToSuperview().inset(16)
//        }
//        levelLabel.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 45, height: 20))
//        }
//        sectorLabel.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 45, height: 20))
//        }
//        dDayLabel.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 45, height: 20))
//        }
        likeStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.57)
            $0.trailing.equalToSuperview().inset(10)
        }
        likeButton.imageView?.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 30))
        }
        likeButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
        }
        commentStackView.snp.makeConstraints {
            $0.top.equalTo(likeStackView.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().inset(10)
        }
        commentButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
            $0.top.equalTo(likeStackView.snp.bottom).offset(20)
        }
        commentButton.imageView?.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
        }
        reportDeleteButton.imageView?.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 25))
        }
        reportDeleteButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 25))
            $0.trailing.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.1)
        }
    }
    
    
    // MARK: - configure 메서드
    func configure(with post: Post, viewModel: MainFeedVM) {
        self.viewModel = viewModel
        likeViewModel = LikeViewModel(post: post)
        FirebaseManager.shared.getUserInfoFrom(uid: post.authorUID) { [weak self] result in
            guard let self else { return }
            switch result {
            case.success(let user):
                if let imageUrlString = user.profileImage {
                    if let imageUrl = URL(string: imageUrlString) {
                        self.feedUserProfileImage.kf.setImage(with: imageUrl)
                    }
                } else {
                    self.feedUserProfileImage.image = UIImage(named: "testStone")
                }
                DispatchQueue.main.async {
                    self.feedUserNameLabel.text = user.userName
                }
            case .failure(let error):
                print(error)
            }
        }
        self.post = post
        Task {
            medias = try await FirebaseManager.shared.fetchMedias(for: post)
            guard let medias else { return }
            if medias.count > 0 {
                self.addSubview(pageControl)
                pageControl.snp.makeConstraints {
                    $0.centerX.equalToSuperview()
                    $0.bottom.equalTo(collectionView.snp.bottom).offset(-40)
                }
                pageControl.numberOfPages = medias.count
                pageControl.currentPage = 0
            }
            collectionView.reloadData()
        }
        
        feedCaptionLabel.text = post.caption
        commentButtonCounter.text = String(post.commentCount ?? 0)
        likeButton.configureHeartButton()
        fetchLike()
        setLikeButton()
    }
    
    func fetchLike() {
        guard let postUID = post?.postUID else  { return }
        FirebaseManager.shared.fetchLike(from: postUID, type: .post)
            .subscribe(onNext: { [weak self] likeList in
                guard let self else { return }
                self.likeViewModel?.postLikeList.accept(likeList)
            }, onError: { error in
                print("Error - \(#file) \(#function) \(#line) : \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - 좋아요 버튼 세팅
    private func setLikeButton() {
        print("Setting LikeButton")
        guard let user = Auth.auth().currentUser,
              let likeViewModel
        else { return }
        likeButton.rx.tap
            .asSignal().emit(onNext: {
                likeViewModel.likePost(myUID: user.uid)
            })
            .disposed(by: disposeBag)
        
        likeViewModel.postLikeList
            .asDriver()
            .drive(onNext: { [weak self] likeList in
                guard let self else { return }
                self.likeButtonCounter.text =  "\(likeList.count)"
                print("LikeList: \(likeList)")
                if likeList.contains([user.uid]) {
                    self.likeButton.isActivated = true
                }  else {
                    self.likeButton.isActivated = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - 버튼 그림자 모드
    private func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
    }
}
// MARK: CollectionView Setting
//extension SFCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let medias else { return 0}
//        return medias.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SFFeedCell.className, for: indexPath) as? SFFeedCell else {
//            return UICollectionViewCell()
//        }
//        guard let medias, let viewModel else { return cell }
//        let currentMedia = medias[indexPath.row]
//        cell.configure(with: currentMedia, viewModel: viewModel)
//        cell.gymTap
//            .bind(to: viewModel.gymButtonTap)
//            .disposed(by: cell.disposeBag)
//        cell.gradeTap
//            .bind(to: viewModel.gradeButtonTap)
//            .disposed(by: cell.disposeBag)
//        return cell
//    }
//    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        stopVideos()
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = Int(round(scrollView.contentOffset.x / self.frame.width))
//        guard pageControl.currentPage != pageIndex else { return } // 페이지가 정확하게 넘어간것만 걸러내기
//        pageControl.currentPage = pageIndex
//    }
//    
//    private func stopVideos() {
//        for cell in collectionView.visibleCells {
//            if let verticalCell = cell as? SFFeedCell {
//                verticalCell.stopVideo()
//            }
//        }
//    }
//}

extension SFCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let medias else { return 0}
        return medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SFFeedCell.className, for: indexPath) as? SFFeedCell else {
            return UICollectionViewCell()
        }
        guard let medias, let viewModel else { return cell }
        let currentMedia = medias[indexPath.row]
        cell.configure(with: currentMedia, viewModel: viewModel)
        cell.gymTap
            .bind(to: viewModel.gymButtonTap)
            .disposed(by: cell.disposeBag)
        cell.gradeTap
            .bind(to: viewModel.gradeButtonTap)
            .disposed(by: cell.disposeBag)
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopVideos()
    }
    
    // MARK: - 사용자가 스크롤을 할 때 호출
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        stopVideos()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / self.frame.width))
        print("스크롤이 끝났습니다. 페이지 인덱스: \(pageIndex)")
        
        guard let medias else {
            print("미디어가 없습니다.")
            return
        }
        
        guard pageIndex >= 0 && pageIndex < medias.count else {
            print("잘못된 페이지 인덱스: \(pageIndex)")
            return
        }
        
        let currentMedia = medias[pageIndex]
        print("현재 미디어 URL: \(currentMedia.url)")
        
        let videoURL = currentMedia.url
        
        guard let url = URL(string: videoURL),
              let lastPathComponent = url.lastPathComponent.lowercased().components(separatedBy: "?").first,
              lastPathComponent.hasSuffix("mp4") else {
            print("비디오 URL이 아닙니다. 비디오 멈춤.")
            self.stopVideos()
            return
        }
        
        print("URL에 해당하는 비디오를 재생하려고 시도: \(videoURL)")
        self.collectionView.visibleCells
            .enumerated()
            .forEach { index, cell in
                guard let feedCell = cell as? SFFeedCell else { return }
                
                if feedCell.media?.url == videoURL {
                    print("비디오를 재생.: \(videoURL)")
                    feedCell.playVideo()
                } else {
                    print("비디오를 멈춥.: \(videoURL)")
                    feedCell.stopVideo()
                }
            }
    }
    
    private func stopVideos() {
        for cell in collectionView.visibleCells {
            if let verticalCell = cell as? SFFeedCell {
                verticalCell.stopVideo()
            }
        }
    }
}
