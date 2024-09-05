//
//  FeedView.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/1/24.
//

import UIKit
import PhotosUI

import SnapKit

class FeedView : UIView {
    
    var mediaItems: [PHPickerResult]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: self.frame.width, height: self.frame.height)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = mediaItems.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        
        return pageControl
    }()
    
    init(frame: CGRect, mediaItems: [PHPickerResult]) {
        self.mediaItems = mediaItems
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
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
    
    
}

extension FeedView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.className, for: indexPath) as? FeedCell else {
            return UICollectionViewCell()
        }
        cell.configure(mediaItem: mediaItems[indexPath.row])
        return cell
    }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // 현재 페이지 인덱스 계산
            let pageIndex = round(scrollView.contentOffset.x / self.frame.width)
            pageControl.currentPage = Int(pageIndex)
            
            // 셀의 비디오 재생 상태를 관리하기 위한 셀의 `configure(with:)` 메서드를 호출
            for cell in collectionView.visibleCells as! [FeedCell] {
                if let indexPath = collectionView.indexPath(for: cell ), indexPath.row == Int(pageIndex) {
                    cell.configure(mediaItem: mediaItems[indexPath.row])
                } else {
                    cell.stopVideo()
                }
            }
        }
    }
