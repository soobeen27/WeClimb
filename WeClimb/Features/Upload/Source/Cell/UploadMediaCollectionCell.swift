//
//  UploadMediaCollectionCell.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit
import AVFoundation

import SnapKit
import Kingfisher

class UploadMediaCollectionCell: UICollectionViewCell {
    private var playerLayer: AVPlayerLayer?
    private var player: AVQueuePlayer?
    private var playerLooper: AVPlayerLooper?
    
    private var isPlaying: Bool = false
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopVideo()
        playerLayer?.removeFromSuperlayer()
        player = nil
    }
    
    private func setLayout() {
        contentView.addSubview(imageView)
        contentView.backgroundColor = UIColor.fillSolidDarkBlack
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with mediaItem: MediaUploadData) {
        let url = mediaItem.url
        
        if url.pathExtension == "jpg" || url.pathExtension == "png" {
            loadImage(from: url)
        } else if url.pathExtension == "mp4" {
            loadVideo(from: url)
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
    
    private func loadVideo(from url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVQueuePlayer(playerItem: playerItem)
        guard let player else { return }
        
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = contentView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        contentView.layer.addSublayer(playerLayer!)
    }
    
    func playVideo() {
        guard let player = player else { return }
        
        VideoManager.shared.UploadPlayNewVideo(player: player)
        self.isPlaying = true
    }
    
    func stopVideo() {
        guard player != nil else { return }
        
        VideoManager.shared.UploadStopVideo()
        self.isPlaying = false
    }
    
    @objc private func handleTap() {
        guard player != nil else { return }
        
        if self.isPlaying {
            self.stopVideo()
        } else {
            self.playVideo()
        }
    }
}
