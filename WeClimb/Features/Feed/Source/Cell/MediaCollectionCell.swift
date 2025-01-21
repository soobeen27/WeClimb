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
    private let videoView = PostVideoView()
    
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
        guard let url = URL(string: mediaItem.url) else { return }
        videoView.videoInfo = (url, mediaItem.mediaUID)
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
        contentView.addSubview(videoView)
        videoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
