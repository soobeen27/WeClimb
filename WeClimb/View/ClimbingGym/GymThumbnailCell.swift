//
//  GymThumbnailCell.swift
//  WeClimb
//
//  Created by 머성이 on 11/13/24.
//

import UIKit

import SnapKit
import Kingfisher

class ThumbnailCell: UICollectionViewCell {
    
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
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func configure(with url: String) {
        // URL을 Kingfisher로 로드하여 이미지 설정
        guard let imageURL = URL(string: url) else {
            imageView.image = UIImage(named: "defaultImage") // URL이 유효하지 않으면 기본 이미지 설정
            return
        }
        
        imageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "defaultImage")) { result in
            switch result {
            case .success(let value):
                print("이미지 로드 성공: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("이미지 로드 실패: \(error.localizedDescription)")
            }
        }
    }
}

