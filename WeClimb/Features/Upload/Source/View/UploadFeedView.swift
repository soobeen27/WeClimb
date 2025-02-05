//
//  UploadFeedView.swift
//  WeClimb
//
//  Created by 강유정 on 2/3/25.
//

import UIKit
import PhotosUI

import SnapKit
import RxRelay
import RxSwift

class UploadFeedView: UIView {
    private var disposeBag = DisposeBag()
    private let viewModel: UploadVM
    var isPlaying: Bool = true
    
    var selectedMediaItems: [MediaUploadData] = []
    
    lazy var collectionView: UICollectionView = {
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        collectionView.decelerationRate = .fast
        collectionView.register(UploadMediaCollectionCell.self, forCellWithReuseIdentifier: UploadMediaCollectionCell.className)
        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.fillSolidDarkBlack

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
        layout.minimumLineSpacing = 12

        let itemWidth: CGFloat = 256
        let itemHeight: CGFloat = self.frame.height

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        let leftInset: CGFloat = (self.frame.width - itemWidth) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: leftInset)

        return layout
    }
    
    private func setLayout() {
        self.backgroundColor = UIColor.fillSolidDarkBlack

        [collectionView]
            .forEach {
                self.addSubview($0)
            }
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindCell() {
        viewModel.cellData
            .bind(to: collectionView.rx.items(
                cellIdentifier: UploadMediaCollectionCell.className,
                cellType: UploadMediaCollectionCell.self)
            ) { row, data, cell in
                
                cell.configure(with: data)
            }
            .disposed(by: disposeBag)
    }
}

extension UploadFeedView: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let itemWidth = layout.itemSize.width
        let spacing = layout.minimumLineSpacing
        let pageWidth = itemWidth + spacing
        
        let proposedContentOffsetX = targetContentOffset.pointee.x + (scrollView.frame.width / 2) - (itemWidth / 2)
        let approximatePage = proposedContentOffsetX / pageWidth
        let currentPage = round(approximatePage)
        
        let targetX = (currentPage * pageWidth) - (scrollView.frame.width / 2) + (itemWidth / 2)
        targetContentOffset.pointee = CGPoint(x: targetX, y: scrollView.contentOffset.y)

        print("넘어갈 페이지: \(Int(currentPage))")
    }

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        VideoManager.shared.reset()
    }
}
