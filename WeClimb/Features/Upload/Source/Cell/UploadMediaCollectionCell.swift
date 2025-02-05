//
//  UploadMediaCollectionCell.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import AVKit
import UIKit
import PhotosUI
import AVFoundation

import SnapKit
import Kingfisher

class UploadMediaCollectionCell: UICollectionViewCell {
    var isDisplayed: Bool = false
    private var playerLayer: AVPlayerLayer?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopVideo()
        playerLayer?.removeFromSuperlayer()
    }
    
    private func setLayout() {
        contentView.addSubview(imageView)
        contentView.backgroundColor = UIColor.fillSolidDarkBlack
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with mediaItem: MediaUploadData) {
        let url = mediaItem.url
        
        if url.pathExtension == "jpg" || url.pathExtension == "png" {
            loadImage(from: url)
        } else if url.pathExtension == "mp4" {
            playVideo(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.cacheOriginalImage]) { result in
            switch result {
            case .success(let value):
                print("이미지 로드 성공: \(value.image)")
            case .failure(let error):
                print("이미지 로드 실패: \(error.localizedDescription)")
                self.imageView.image = UIImage(named: "placeholder")
            }
        }
    }
    
    private func playVideo(from url: URL) {
        let player = AVQueuePlayer(url: url)
        VideoManager.shared.playVideo(player: player)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = contentView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        contentView.layer.addSublayer(playerLayer!)
    }
    
    private func stopVideo() {
        VideoManager.shared.stopVideo()
    }

}
