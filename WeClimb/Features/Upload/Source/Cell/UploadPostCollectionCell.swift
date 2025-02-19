//
//  UploadPostCollectionCell.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit
import AVFoundation

import SnapKit
import Kingfisher

class UploadPostCollectionCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill 
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 11
        imageView.layer.masksToBounds = true
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
        imageView.image = nil
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
            loadVideoThumbnail(from: url)
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

    private func loadVideoThumbnail(from url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true

            do {
                let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)

                DispatchQueue.main.async {
                    self.imageView.image = thumbnail
                }
            } catch {
                print("썸네일 생성 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "placeholder")
                }
            }
        }
    }
}
