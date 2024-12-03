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
    
    func configure(with thumbnailURL: String) {
//        print("썸네일 url 확인\(thumbnailURL)")

        imageView.kf.setImage(with: URL(string: thumbnailURL), placeholder: nil)
//        { result in
//            switch result {
//            case .success(let value):
//                print("이미지 로드 성공: \(value.source.url?.absoluteString ?? "")")
//            case .failure(let error):
//                print("이미지 로드 실패: \(error.localizedDescription)")
//            }
//        }
    }
}
