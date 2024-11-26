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
    var isPlaying: Bool = true
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: self.frame.width, height: self.frame.height)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        
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
        bindCell()
        setGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [collectionView, pageControl]
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
    }
    
    // MARK: - 모든 셀의 비디오를 멈추는 메서드 YJ
    func pauseAllVideo() {
        collectionView.visibleCells     // 현재 화면에 표시되고 있는 셀들 가져오기
            .forEach { cell in          // 각 셀 순회해서 비디오 멈추기
                if let feedCell = cell as? FeedCell {
                    feedCell.stopVideo()
                }
            }
    }
    
    // MARK: - 현재 셀의 비디오를 실행시키는 메서드 YJ
    func playAllVideo() {
        collectionView.visibleCells
            .forEach { cell in
                if let feedCell = cell as? FeedCell {
                    feedCell.playVideo()
                }
            }
    }
    
    private func setGesture() {
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        self.addGestureRecognizer(TapGesture)
    }
    
    @objc private func handleDoubleTap() {
        let visibleCells = collectionView.visibleCells
        if isPlaying {
            for cell in visibleCells {
                if let feedCell = cell as? FeedCell {
                    feedCell.stopVideo()
                }
            }
        } else {
            for cell in visibleCells {
                if let feedCell = cell as? FeedCell {
                    feedCell.playVideo()
                }
            }
            print("비디오 재생")
        }
    }
    
    private func bindCell() {
        viewModel.cellData
            .bind(to: collectionView.rx.items(
                cellIdentifier: FeedCell.className, cellType: FeedCell.self)
            ) { row, data, cell in
                print("data: \(data)")
                cell.configure(with: data)
                
                if self.pageControl.currentPage == row,
                   self.pageControl.currentPage == 0 {
                    cell.playVideo()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension FeedView : UICollectionViewDelegate {
    // MARK: - 사용자가 스크롤을 할 때 호출
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 현재 페이지 인덱스 계산
        let pageIndex = Int(round(scrollView.contentOffset.x / self.frame.width))
        guard pageControl.currentPage != pageIndex else { return } // 페이지가 정확하게 넘어간것만 걸러내기
        pageControl.currentPage = pageIndex
        
        // 페이지 변경 시 클로저 호출
        viewModel.pageChanged(to: pageIndex)
        
        isPlaying = true
        
        let changedItem = viewModel.feedRelay.value[pageIndex]
        
        if changedItem.imageURL != nil {
            pauseAllVideo()
            return
        }
        
        collectionView.visibleCells // 현재 화면에 표시되고 있는 셀들 반환
            .enumerated()
            .forEach { index, cell in
                guard let feedCell = cell as? FeedCell else { return }
                
                if feedCell.data?.videoURL == changedItem.videoURL {
                    feedCell.playVideo()
                } else {
                    feedCell.stopVideo()
                }
            }
    }
}
