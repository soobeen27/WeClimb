//
//  AlbumCell.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

import SnapKit

class AlbumCell: UICollectionViewCell {
    
    private let albumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private let albumName: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = "text"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = .systemBackground
        [albumImage, albumName]
            .forEach {
                self.addSubview($0)
            }
        
        albumImage.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.size.equalTo(CGSize(width: self.frame.width, height: self.frame.width))
        }
        
        albumName.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(albumImage.snp.bottom).offset(8)
        }
    }
    
    func configure(image: UIImage, name: String) {
        albumImage.image = image
        albumName.text = name
    }
}
