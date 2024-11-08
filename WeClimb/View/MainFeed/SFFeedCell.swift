//
//  SFFeedCell.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/26/24.
//

import AVKit
import AVFoundation
import UIKit

import SnapKit

class SFFeedCell: UICollectionViewCell {
    var imageView: UIImageView!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var isVideo: Bool = false
    
    let playButton: UIButton = {
        let button = UIButton()
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
        resetPlayer()
        imageView.image = nil
        media = nil
    }
    
    func configure(with media: Media) {
        guard let url = URL(string: media.url) else { return }
        imageView.image = nil
        resetPlayer()
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
        resetPlayer()
        let cacheKey = "\(media.mediaUID).mp4" // 예: userUID 또는 postID
        
        streamAndCacheVideo(with: videoURL, cacheKey: cacheKey) { [weak self] cachedURL in
            guard let self = self, let cachedURL = cachedURL else {
                print("비디오 다운로드 또는 캐싱 실패")
                return
            }
            
            DispatchQueue.main.async {
                self.setupPlayer(with: cachedURL)
            }
        }
    }
    
    private func setupPlayer(with url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.contentView.bounds
        playerLayer?.videoGravity = .resizeAspect
        if let playerLayer = self.playerLayer {
            self.contentView.layer.addSublayer(playerLayer)
        }
        setupPlayButton()
        playButton.isHidden = false
        self.contentView.bringSubviewToFront(playButton)
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
    
    private func resetPlayer() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        isVideo = false
        playButton.isHidden = true
    }
    
    func streamAndCacheVideo(with url: URL, cacheKey: String, completion: @escaping (URL?) -> Void) {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cachedFileURL = cacheDirectory.appendingPathComponent(cacheKey)
        
        if FileManager.default.fileExists(atPath: cachedFileURL.path) {
            print("이미 캐시된 파일이 존재: \(cachedFileURL.path)")
            completion(cachedFileURL)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: url) { (location, response, error) in
            if let error = error {
                print("Error downloading video: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let location = location else {
                print("다운로드된 파일이 없습니다.")
                completion(nil)
                return
            }
            
            print("다운로드 완료, 파일 위치: \(location.path)")
            
            do {
                try FileManager.default.moveItem(at: location, to: cachedFileURL)
                print("파일을 캐시 디렉토리로 이동 완료: \(cachedFileURL.path)")
                completion(cachedFileURL)
            } catch {
                print("파일 이동 중 오류 발생: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        print("다운로드 시작: \(url.absoluteString)")
        task.resume()
    }
}
