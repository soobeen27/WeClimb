//
//  UploadFeedView.swift
//  WeClimb
//
//  Created by 강유정 on 2/3/25.
//

import UIKit

import SnapKit
import RxSwift

class UploadFeedView: UIView {
    private var disposeBag = DisposeBag()
    private let viewModel: UploadVM
    
    var selectedMediaItems: [MediaUploadData] = []
    
    private var totalMediaCount: Int = 0
    var onMediaIndexChanged: ((Int) -> Void)?
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UploadMediaConst.FeedView.Font.countLabel
        label.textColor = UploadMediaConst.FeedView.Color.countLabelText
        label.layer.cornerRadius = UploadMediaConst.FeedView.Size.countLabelCornerRadius
        label.clipsToBounds = true
        label.backgroundColor = UploadMediaConst.FeedView.Color.countLabelBackground
        label.textAlignment = .center
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.register(UploadMediaCollectionCell.self, forCellWithReuseIdentifier: UploadMediaCollectionCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.fillSolidDarkBlack
        collectionView.delegate = self
        return collectionView
    }()
    
    init(frame: CGRect, viewModel: UploadVM) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setLayout()
        bindCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = UploadMediaConst.FeedView.Size.CollectionViewItemSpacing
        
        let itemWidth: CGFloat = UploadMediaConst.FeedView.Size.CollectionViewItemWidth
        let itemHeight: CGFloat = self.frame.height
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let inset: CGFloat = UploadMediaConst.FeedView.Size.CollectionViewInset(viewWidth: self.frame.width)
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        return layout
    }
    
    private func setLayout() {
        self.backgroundColor = UploadMediaConst.FeedView.Color.CollectionViewBackground
        
        [collectionView, countLabel]
            .forEach { self.addSubview($0) }
        
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UploadMediaConst.FeedView.Layout.CountLabelTopOffset)
            $0.trailing.equalToSuperview().offset(UploadMediaConst.FeedView.Layout.CountLabelTrailingOffset)
            $0.width.equalTo(UploadMediaConst.FeedView.Layout.CountLabelWidth)
            $0.height.equalTo(UploadMediaConst.FeedView.Layout.CountLabelHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(UploadMediaConst.FeedView.Layout.CollectionViewTopOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    
    private func bindCell() {
        self.viewModel.mediaUploadDataRelay
            .take(1)
            .bind(to: collectionView.rx.items(
                cellIdentifier: UploadMediaCollectionCell.className,
                cellType: UploadMediaCollectionCell.self)
            ) { row, data, cell in
                cell.configure(with: data)
                self.playFirstMedia()
            }
            .disposed(by: disposeBag)

        self.viewModel.mediaUploadDataRelay
            .observe(on: MainScheduler.instance)
            .bind { [weak self] mediaItems in
                guard let self = self else { return }
                if !mediaItems.isEmpty {
                    self.totalMediaCount = mediaItems.count
                    self.updateCurrentIndex()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func playFirstMedia() {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? UploadMediaCollectionCell {
            cell.playVideo()
        }
        countLabel.text = String(format: UploadMediaConst.FeedView.Text.countLabelFormat, UploadMediaConst.FeedView.Scroll.firstMediaDisplayIndex, totalMediaCount)
    }
}

extension UploadFeedView: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let largeItemWidth: CGFloat = UploadMediaConst.FeedView.Size.CollectionViewItemWidth
        let spacing: CGFloat = UploadMediaConst.FeedView.Size.CollectionViewItemSpacing
        
        let moveDistance = largeItemWidth + spacing
        
        let sectionInset = UploadMediaConst.FeedView.Size.CollectionViewInset(viewWidth: self.frame.width)
        
        let approximatePage = (scrollView.contentOffset.x + sectionInset) / moveDistance
        var nearestPage = round(approximatePage)
        
        if velocity.x > UploadMediaConst.FeedView.Scroll.speedLimit {
            nearestPage = floor(approximatePage + CGFloat(UploadMediaConst.FeedView.Scroll.nextPageOffset))
        } else if velocity.x < -UploadMediaConst.FeedView.Scroll.speedLimit {
            nearestPage = ceil(approximatePage - CGFloat(UploadMediaConst.FeedView.Scroll.nextPageOffset))
        }
        
        var targetX = (nearestPage * moveDistance)

        if nearestPage == CGFloat(UploadMediaConst.FeedView.Scroll.firstMediaIndex) {
            targetX -= sectionInset
        }

        let maxPage = ceil(scrollView.contentSize.width / moveDistance) - CGFloat(UploadMediaConst.FeedView.Scroll.nextPageOffset)
        if nearestPage >= maxPage {
            targetX += sectionInset
        }
        
        targetX = round(targetX / moveDistance) * moveDistance
        
        targetContentOffset.pointee.x = targetX
        
        VideoManager.shared.UploadStopVideo()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentIndex()
    }
    
    func updateCurrentIndex() {
        let itemWidth: CGFloat = UploadMediaConst.FeedView.Size.CollectionViewItemWidth
        let spacing: CGFloat = UploadMediaConst.FeedView.Size.CollectionViewItemSpacing
        let moveDistance = itemWidth + spacing
        
        let currentPageIndex = Int(collectionView.contentOffset.x / moveDistance)
        
        onMediaIndexChanged?(currentPageIndex)
        
        countLabel.text = String(format: UploadMediaConst.FeedView.Text.countLabelFormat, currentPageIndex + UploadMediaConst.FeedView.Scroll.nextPageOffset, self.totalMediaCount)
        
        if let indexPath = IndexPath(row: currentPageIndex, section: 0) as IndexPath?,
           let cell = collectionView.cellForItem(at: indexPath) as? UploadMediaCollectionCell {
            cell.playVideo()
        }
    }
}
