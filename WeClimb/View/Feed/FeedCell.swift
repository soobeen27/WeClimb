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
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = contentView.bounds
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    var videoURL: URL?
    
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
    }
    
    func playVideo(url: URL) {
        stopVideo()
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = contentView.bounds
        if let playerLayer = playerLayer {
            contentView.layer.addSublayer(playerLayer)
        }
        
        player?.play()
        
    }
    
    func stopVideo() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
    }
    
    private func setLayout() {
        [imageView]
            .forEach {
                contentView.addSubview($0)
            }
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(mediaItem: PHPickerResult) {
        
        if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
            mediaItem.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] (url, error) in
                guard let self = self, let url = url, error == nil else { return }
                
                mediaItem.itemProvider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { [weak self] (item, error) in
                    if let videoURL = item as? URL {
                        DispatchQueue.main.async {
                            self?.playVideo(url: videoURL)
                        }
                    }
                }
            }
        } else if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            mediaItem.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    self?.imageView.image = image as? UIImage
                }
            }
        }
    }
}
    
// 이 코드 잠깐 주석 달아놓을께요,, YJ
//    func configure(mediaItem: PHPickerResult) {
//        if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
//            mediaItem.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { (url, error)  in
//                guard let url else { return }
//
//                self.copyVideoToDocumentsDirectory(videoURL: url) { url in
//                    DispatchQueue.main.async {
//                        self.playVideo(url: url)
//                    }
//                }
//            }
//        } else if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
//            mediaItem.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//                DispatchQueue.main.async {
//                    self.imageView.image = image as? UIImage
//                }
//            }
//        }
//    }
//
//    private func copyVideoToDocumentsDirectory(videoURL: URL, completion: @escaping (URL) -> Void) {
//        let fileManager = FileManager.default
//        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let destinationURL = documentsDirectory.appendingPathComponent(videoURL.lastPathComponent)
//        
//        do {
//            if fileManager.fileExists(atPath: destinationURL.path) {
//                try fileManager.removeItem(at: destinationURL)
//            }
//            try fileManager.copyItem(at: videoURL, to: destinationURL)
//            completion(destinationURL)
//        } catch {
//            print("Failed to copy video file: \(error)")
//        }
//    }
//}
