//
//  FeedView.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/1/24.
//

import UIKit
import PhotosUI

import SnapKit
import RxRelay
import RxSwift

class FeedView : UIView {
    private var disposeBag = DisposeBag()
    
    private let viewModel: UploadVM
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: self.frame.width, height: self.frame.height)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = viewModel.mediaItems.value.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        
        return pageControl
    }()
    
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(frame: CGRect, viewModel: UploadVM) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setLayout()
        bind()
        setLoading()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        [collectionView, pageControl, loadingIndicator]
            .forEach {
                self.addSubview($0)
            }
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bind() {
        setLoading()
        viewModel.feedRelay
            .bind(to: collectionView.rx.items(
                cellIdentifier: FeedCell.className, cellType: FeedCell.self)
            ) { row, element, cell in
                // 셀에 데이터 설정
                cell.configure(with: element)
                // 첫 번째 셀에 비디오 URL이 있다면 비디오 재생
                if row == 0, element.videoURL != nil {
                    cell.playVideo()
                }
            }
            .disposed(by: disposeBag)
        
        // 델리게이트 self 설정
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setLoading() {
//        viewModel.isLoading
//            .observe(on: MainScheduler.instance)
//            .bind(to: loadingIndicator.rx.isAnimating)
//            .disposed(by: disposeBag)
        
        // 그냥 프린트문 찍어보려고 명시적으로 해본거...
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isLoading in
                print("isLoading 값: \(isLoading)") // 값 확인용 로그 추가
                if isLoading {
                    print("로딩 중입니다.")
                    self.loadingIndicator.startAnimating()
                } else {
                    print("로딩이 완료되었습니다.")
                    self.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension FeedView : UICollectionViewDelegate {
    // MARK: - 사용자가 스크롤을 할 때 호출
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 현재 페이지 인덱스 계산
        let pageIndex = Int(round(scrollView.contentOffset.x / self.frame.width))
        pageControl.currentPage = pageIndex
        
        collectionView.visibleCells // 현재 화면에 표시되고 있는 셀들 반환
            .enumerated()
            .forEach { index, cell in
                guard let feedCell = cell as? FeedCell else { return }
                if index == pageIndex {
                    feedCell.playVideo()
                } else {
                    feedCell.stopVideo()
                }
            }
    }
}
