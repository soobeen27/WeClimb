//
//  FeedCell.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/1/24.
//
import AVKit
import UIKit
import PhotosUI

import SnapKit

class FeedCell : UICollectionViewCell {
    
    var isDisplayed: Bool = false
    var data: FeedCellModel? // 셀에 대한 데이터를 저장하는 속성
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = contentView.bounds
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 셀이 재사용되기 전 호출되는 메서드 YJ
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stopVideo()
        playerLayer?.removeFromSuperlayer()
    }
    
    // MARK: - 비디오 재생 메서드 YJ
    func readyVideo() {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = contentView.bounds
        playerLayer?.backgroundColor = UIColor(named: "BackgroundColor")?.cgColor
        if let playerLayer = playerLayer {
            contentView.layer.addSublayer(playerLayer)
        }
//        playVideo()
    }
    
    // 비디오 재생
     func playVideo() {
         player?.play()
     }
    
    // MARK: - 비디오 정지 메서드 YJ
    func stopVideo() {
        player?.pause()
    }
    
    private func setLayout() {
        contentView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [imageView]
            .forEach {
                contentView.addSubview($0)
            }
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - 셀을 구성하는 메서드 YJ
    func configure(with model: FeedCellModel) {
        self.data = model // 데이터 저장
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
//            if let image = model.imageURL {
//                // URL에서 이미지 데이터를 가져와서 UIImage 객체로 변환
//                print(image)
//                if let imageData = try? Data(contentsOf: image), let image = UIImage(data: imageData) {
//                    self.imageView.image = image
//                }
//                DispatchQueue.main.sync {
//                    self.stopVideo()
//                }
//            } else 
            if let videoURL = model.videoURL {
                player = AVPlayer(url: videoURL)
                print(videoURL)
                DispatchQueue.main.sync {
                    self.readyVideo()
                }
            }
        }
    }
}
