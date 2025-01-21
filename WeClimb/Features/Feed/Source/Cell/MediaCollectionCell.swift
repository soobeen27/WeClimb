//
//  MediaCollectionCell.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MediaCollectionCell: UICollectionViewCell {
    
    private var viewModel: MediaCollectionCellVM?
    
    var disposeBag = DisposeBag()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(mediaItem: MediaItem, mediaCollectionCellVM: MediaCollectionCellVM) {
        viewModel = mediaCollectionCellVM
        bindViewModel(mediaItem: mediaItem)
        label.text = mediaItem.mediaUID
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
//        viewModel = nil
    }
    
    private func bindViewModel(mediaItem: MediaItem) {
        guard let viewModel else { return }
//        let output = viewModel.transform(input: MediaCollectionCellVMImpl.Input(mediaPath: mediaPath))
//        
//        output.mediaItem
//            .asDriver(onErrorDriveWith: .empty())
//            .drive(onNext: { [weak self] media in
//                self?.label.text = media.mediaUID
//            })
//            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        self.contentView.addSubview(label)
        self.contentView.backgroundColor = .clear
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
