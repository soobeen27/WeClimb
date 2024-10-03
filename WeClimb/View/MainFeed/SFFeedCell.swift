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
        let cacheKey = "\(media.mediaUID).mp4" // 예: userUID 또는 postID
        
        downloadAndCacheVideo(with: videoURL, cacheKey: cacheKey) { [weak self] cachedURL in
            guard let cachedURL = cachedURL,
                  let self
            else {
                print("비디오 다운로드 또는 캐싱 실패")
                return
            }
            
            DispatchQueue.main.async {
                self.player = AVPlayer(url: cachedURL)
                self.playerLayer = AVPlayerLayer(player: self.player)
                self.playerLayer?.frame = self.contentView.bounds
                self.playerLayer?.videoGravity = .resizeAspect
                if let playerLayer = self.playerLayer {
                    self.contentView.layer.addSublayer(playerLayer)
                }
                self.setupPlayButton()
                self.isVideo = true
                self.playButton.isHidden = false
                self.contentView.bringSubviewToFront(self.playButton)
//                self.player?.seek(to: .zero)
//                self.player?.play()
//                self.playVideo()
            }
        }
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
        player?.seek(to: .zero) // 비디오 끝나면 처음으로 돌려놓기
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
    func downloadAndCacheVideo(with url: URL, cacheKey: String, completion: @escaping (URL?) -> Void) {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = cacheDirectory.appendingPathComponent(cacheKey)
        
        // 이미 캐싱된 파일이 있는지 확인
        if FileManager.default.fileExists(atPath: fileURL.path) {
            completion(fileURL)
            return
        }
        
        // URLSession을 사용하여 비디오 파일 다운로드
        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            guard let localURL = localURL, error == nil else {
                completion(nil)
                return
            }
            
            do {
                // 파일을 캐시 디렉토리에 저장
                try FileManager.default.moveItem(at: localURL, to: fileURL)
                completion(fileURL)
            } catch {
                print("파일 저장 에러: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
}

