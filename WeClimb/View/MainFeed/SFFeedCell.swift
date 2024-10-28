//
//  SFFeedCell.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/26/24.
//

import UIKit
import AVKit

import SnapKit
import Kingfisher

class SFFeedCell: UICollectionViewCell {
    var imageView: UIImageView!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var isVideo: Bool = false
    
    let playButton: UIButton = {
        let button = UIButton()
//        button.setImage(UIImage(named: "play.circle"), for: .normal)
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .gray
        return button
    }()
    
    var media: Media?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(hex: "#0B1013")
        // 이미지 뷰 초기화
        imageView = UIImageView(frame: contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        contentView.addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.center.equalTo(contentView)
            $0.size.equalTo(75)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        stopVideo() // 셀 재사용 시 비디오 정지
        media = nil
        playerLayer?.removeFromSuperlayer()
        playButton.isHidden = true
        player = nil
        playerLayer = nil
    }
    
    func configure(with media: Media) {
        guard let url = URL(string: media.url) else { return }
        imageView.image = nil
        playerLayer?.removeFromSuperlayer()
        player = nil // 플레이어 해제
        playerLayer = nil // 레이어 해제
        playButton.isHidden = true
        self.media = media
        if url.pathExtension == "mp4" {
            loadVideo(from: media)
        } else {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        self.isVideo = false
        self.playButton.isHidden = true
        imageView.kf.setImage(with: url)
    }
    
    private func loadVideo(from media: Media) {
        guard let videoURL = URL(string: media.url) else { return }
        let playerItem = AVPlayerItem(url: videoURL)
        playerItem.preferredForwardBufferDuration = 0.5
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = contentView.bounds
        playerLayer?.videoGravity = .resizeAspect
        if let playerLayer = playerLayer {
            contentView.layer.addSublayer(playerLayer)
        }
        
        setupPlayButton()
        self.isVideo = true
        self.playButton.isHidden = false
        self.contentView.bringSubviewToFront(self.playButton)
    }
    
    func setupPlayButton() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    @objc func playButtonTapped() {
        player?.play()
        playButton.isHidden = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    
    @objc func playerDidFinishPlaying() {
        playButton.isHidden = false
        self.contentView.bringSubviewToFront(self.playButton)
        player?.seek(to: .zero)
    }
    
    func stopVideo() {
        if isVideo {
            playButton.isHidden = false
            self.contentView.bringSubviewToFront(self.playButton)
            player?.pause()
        }
    }
    
    func playVideo() {
        print("Play")

        player?.seek(to: .zero)
        player?.play()
        playButton.isHidden = true
    }
}

