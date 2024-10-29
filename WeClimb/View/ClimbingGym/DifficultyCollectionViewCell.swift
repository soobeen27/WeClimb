//
//  ClimbingTableViewCell.swift
//  WeClimb
//
//  Created by 머성이 on 8/26/24.
//

import UIKit

import SnapKit

class DifficultyCollectionViewCell: UICollectionViewCell {
 
    let iconImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [
            iconImage
        ].forEach { contentView.addSubview($0) }
        
        iconImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(contentView.snp.width)
        }
    }
    
    func configure(with grade: String) {
        contentView.backgroundColor = grade.colorInfo.color.withAlphaComponent(0.6)
        contentView.layer.cornerRadius = 16
    }
    
}
