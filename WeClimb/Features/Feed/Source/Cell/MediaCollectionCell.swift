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
import Kingfisher

class MediaCollectionCell: UICollectionViewCell {
    var disposeBag = DisposeBag()

    lazy var videoView: PostVideoView = {
        let v = PostVideoView(frame: contentView.bounds)
        return v
    }()
    
    private var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(mediaItem: MediaItem) {
        guard let url = URL(string: mediaItem.url) else { return }
        if isVideo(url: url) {
            setVideoView(info: (url, mediaItem.mediaUID))
        } else {
            setImageView(url: url)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        videoView.resetToDefaultState()
        imageView = nil
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
    private func setVideoView(info: (url: URL, uid: String)) {
        videoView.videoInfo = info
        contentView.addSubview(videoView)
    }
    
    private func setImageView(url: URL) {
        imageView = UIImageView(frame: contentView.bounds)
        guard let imageView else { return }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.kf.setImage(with: url)
        contentView.addSubview(imageView)
    }
    
    private func isVideo(url: URL) -> Bool {
        if url.pathExtension == "mp4" {
            return true
        } else {
            return false
        }
    }
}
