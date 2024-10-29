//
//  ClimbingTableViewCell.swift
//  WeClimb
//
//  Created by 머성이 on 8/26/24.
//

import UIKit

import SnapKit

class DifficultyCollectionViewCell: UICollectionViewCell {
 
    private let holdImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [
            holdImageView
        ].forEach { contentView.addSubview($0) }
        
        holdImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configure(with grade: String, holdImage: UIImage) {
        contentView.backgroundColor = grade.colorInfo.color.withAlphaComponent(0.8)
        contentView.layer.cornerRadius = 16
        
        holdImageView.image = holdImage
    }
}
