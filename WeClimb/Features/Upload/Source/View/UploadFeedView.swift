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
    var isPlaying: Bool = true
    
    var selectedMediaItems: [MediaUploadData] = []
    
    private var totalMediaCount: Int = 0
    var onMediaIndexChanged: ((Int) -> Void)?
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(style: .caption1Medium)
        label.textColor = .white
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        label.text = "1 / \(totalMediaCount)"
        label.backgroundColor = UIColor.init(hex: "313235", alpha: 0.4)  // fillOpacityDarkHeavy
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
        DispatchQueue.main.async { [weak self] in
            self?.playFirstMedia()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        let itemWidth: CGFloat = 256
        let itemHeight: CGFloat = self.frame.height
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let inset: CGFloat = (self.frame.width - itemWidth) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        return layout
    }
    
    private func setLayout() {
        self.backgroundColor = UIColor.clear
        
        [collectionView, countLabel]
            .forEach { self.addSubview($0) }
        
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(41)
            $0.height.equalTo(26)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindCell() {
        self.viewModel.mediaUploadDataRelay
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(
                cellIdentifier: UploadMediaCollectionCell.className,
                cellType: UploadMediaCollectionCell.self)
            ) { row, data, cell in
                cell.configure(with: data)
            }
            .disposed(by: disposeBag)

        self.viewModel.mediaUploadDataRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] mediaItems in
                guard let self = self else { return }

                if !mediaItems.isEmpty {
                    self.totalMediaCount = mediaItems.count
                    self.updateCurrentIndex()
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        self.playFirstMedia()
//                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func playFirstMedia() {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? UploadMediaCollectionCell {
            cell.playVideo()
        }
        countLabel.text = "1 / \(totalMediaCount)"
    }
}

extension UploadFeedView: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let largeItemWidth: CGFloat = 256
        let spacing: CGFloat = 12
        
        let moveDistance = largeItemWidth + spacing
        
        let sectionInset = (self.frame.width - largeItemWidth) / 2
        
        let approximatePage = (scrollView.contentOffset.x + sectionInset) / moveDistance
        var nearestPage = round(approximatePage)
        
        if velocity.x > 0.4 {
            nearestPage = floor(approximatePage + 1)
        } else if velocity.x < -0.4 {
            nearestPage = ceil(approximatePage - 1)
        }
        
        var targetX = (nearestPage * moveDistance)
        
        if nearestPage == 0 {
            targetX -= sectionInset
        }
        
        let maxPage = ceil(scrollView.contentSize.width / moveDistance) - 1
        if nearestPage >= maxPage {
            targetX += sectionInset
        }
        
        targetX = round(targetX / moveDistance) * moveDistance
        
        targetContentOffset.pointee.x = targetX
        
        VideoManager.shared.stopVideo()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentIndex()
    }
    
    private func updateCurrentIndex() {
        let itemWidth: CGFloat = 256
        let spacing: CGFloat = 12
        let moveDistance = itemWidth + spacing
        
        let currentPageIndex = Int(collectionView.contentOffset.x / moveDistance)
        
        onMediaIndexChanged?(currentPageIndex)
        
        countLabel.text = "\(currentPageIndex + 1) / \(self.totalMediaCount)"
        
        if let indexPath = IndexPath(row: currentPageIndex, section: 0) as IndexPath?,
           let cell = collectionView.cellForItem(at: indexPath) as? UploadMediaCollectionCell {
            cell.playVideo()
        }
    }
}
