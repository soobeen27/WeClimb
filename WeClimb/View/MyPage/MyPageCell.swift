//
//  MyPageCell.swift
//  WeClimb
//
//  Created by 강유정 on 8/27/24.
//

import UIKit

import SnapKit
import Kingfisher
import AVFoundation

class MyPageCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFill 
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
        func configure(with url: String) {
            print("URL: \(url)")
            if url.hasSuffix(".mp4") {
                if let videoURL = URL(string: url) {
                    getThumbnailImage(from: videoURL) { [weak self] image in
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                        }
                    }
                }
            } else {
                if let imageUrl = URL(string: url) {
                    imageView.kf.setImage(with: imageUrl)
                }
            }
        }
        
        // 비디오 썸네일 이미지를 생성
        private func getThumbnailImage(from videoURL: URL, completion: @escaping (UIImage?) -> Void) {
            let asset = AVAsset(url: videoURL)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            
            let time = CMTime(seconds: 600, preferredTimescale: 600) // 600 -> 1초
            imageGenerator.requestedTimeToleranceBefore = .zero
            imageGenerator.requestedTimeToleranceAfter = .zero
            
            imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, image, _, result, error in
                if let error = error {
                    print("Error generating thumbnail: \(error)")
                    completion(nil)
                } else if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            }
        }
    }
