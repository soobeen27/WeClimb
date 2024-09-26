//
//  SFFeedCell.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/26/24.
//

import UIKit
import AVKit

class SFFeedCell: UICollectionViewCell {
    var imageView: UIImageView!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var media: Media?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 이미지 뷰 초기화
        imageView = UIImageView(frame: contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
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
        player = nil
        playerLayer = nil
    }
    
    func configure(with media: Media) {
        guard let url = URL(string: media.url) else { return }
        playerLayer?.removeFromSuperlayer()
        player = nil // 플레이어 해제
         playerLayer = nil // 레이어 해제
        self.media = media
        if url.pathExtension == "mp4" {
            loadVideo(from: media)
        } else {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    private func loadVideo(from media: Media) {
        //        player = AVPlayer(url: url)
        //        playerLayer = AVPlayerLayer(player: player)
        //        playerLayer?.frame = contentView.bounds
        //        playerLayer?.videoGravity = .resizeAspect
        //        if let playerLayer = playerLayer {
        //            contentView.layer.addSublayer(playerLayer)
        //        }
        //        player?.play() // 비디오 재생 시작
        
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
                self.player?.seek(to: .zero)
                self.player?.play()
            }
        }
    }
    
    func stopVideo() {
        player?.pause() // 비디오 정지
    }
    func playVideo() {
        player?.seek(to: .zero) // 비디오를 처음으로 되돌림
        player?.play()
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

