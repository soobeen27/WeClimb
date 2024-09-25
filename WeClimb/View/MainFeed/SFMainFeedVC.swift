//
//  MainFeedVC_SF.swift
//  WeClimb
//
//  Created by 김솔비 on 9/5/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class SFMainFeedVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MainFeedVM()
    
    private var posts: [(post: Post, media: [Media])] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0  //셀간 여백 조정(효과없음)
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //플로우 레이아웃 인셋 조정(효과없음)
        return UICollectionView(frame: .zero, collectionViewLayout: layout) //레이아웃을 반환
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTabBar()
        setCollectionView()
        setLayout()
        
        bindViewModel()
    }
    
    // MARK: - 데이터 바인딩
       private func bindViewModel() {
           // ViewModel의 데이터 바인딩
           viewModel.posts
               .observe(on: MainScheduler.instance)
               .subscribe(onNext: { [weak self] posts in
                   self?.posts = posts
                   self?.collectionView.reloadData()
               })
               .disposed(by: disposeBag)
           
           // ViewModel에서 피드 데이터를 가져오는 메서드 호출
           viewModel.fetchInitialFeed()
       }
    
    //MARK: - 네비게이션바, 탭바 세팅
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        rightButton.tintColor = .white
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40) // 버튼 크기
        
        rightButton.layer.shadowColor = UIColor.black.cgColor // 그림자 색상
        rightButton.layer.shadowOffset = CGSize(width: 1, height: 1) // 그림자 위치
        rightButton.layer.shadowOpacity = 0.5 // 그림자 투명도
        rightButton.layer.shadowRadius = 2 // 그림자의 흐림(퍼짐) 정도
        rightButton.layer.masksToBounds = false // 테두리에 그림자가 잘리지 않도록 설정
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc private func rightButtonTapped() {
        actionSheet()
    }
    
    @objc private func rightButtonTapped() {
            actionSheet()
        }
    
    private func setTabBar(){
        if let tabBar = self.tabBarController?.tabBar {
            tabBar.backgroundImage = UIImage()  //탭바 배경 투명하게 설정
            //            tabBar.shadowImage = UIImage()  //탭바 하단 그림자 제거
            tabBar.isTranslucent = true  //탭바 반투명
            tabBar.backgroundColor = .clear  //탭바 배경투명
        }
    }
    
    //MARK: - 컬렉션뷰 & 레이아웃 설정
    private func setCollectionView() {
        collectionView.register(SFCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.mainCollectionViewCell)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds  //컬렉션뷰 셀 프레임을 화면 전체에 맞춤
        collectionView.isPagingEnabled = true  //스크롤 시 한 화면씩 넘기기(페이징 모드 활성화)
        collectionView.contentInsetAdjustmentBehavior = .never  //네비게이션바 자동 여백 삭제
        collectionView.showsHorizontalScrollIndicator = false //스크롤바 숨김 옵션
    }
    
    
    private func setLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - 더보기 액션 시트
    private func actionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            self?.reportModal()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        
        [reportAction, cancelAction]
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
    
    //MARK: - 댓글 모달 시트
    private func commentModal() {
        let modalVC = FeedCommentModalVC()
        presentModal(modalVC: modalVC)
    }
}

//MARK: - 컬렉션뷰 프로토콜 설정
extension SFMainFeedVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.mainCollectionViewCell, for: indexPath) as? SFCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let postData = posts[indexPath.item]
        cell.configure(with: postData.post, media: postData.media)
        
        cell.commentButton.rx.tap
            .bind { [weak self] in
                self?.showCommentModal(for: postData.post)
            }
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // MARK: - 신고하기 및 댓글 모달 표시
    private func showActionSheet(for post: Post) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            self?.reportModal()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [reportAction, cancelAction].forEach {
            actionSheet.addAction($0)
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showCommentModal(for post: Post) {
        let modalVC = FeedCommentModalVC()
        presentModal(modalVC: modalVC)
    }
}
