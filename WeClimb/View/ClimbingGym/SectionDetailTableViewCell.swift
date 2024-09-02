//
//  SectionDetailTableViewCell.swift
//  WeClimb
//
//  Created by 머성이 on 8/30/24.
//

import UIKit

import SnapKit

class SectionDetailTableViewCell: UITableViewCell {
    
    private let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .lightGray
        
        [
            detailImageView,
            detailLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayout() {
        detailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(8)
            $0.width.height.equalTo(80)
        }
        
        detailLabel.snp.makeConstraints {
            $0.leading.equalTo(detailImageView.snp.trailing).offset(16)
            $0.centerY.equalTo(detailImageView)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    
    func configure(with item: DetailItem) {
        detailImageView.image = item.image
        detailLabel.text = item.description
    }
}

struct DetailItem {
    let image: UIImage?
    let description: String
}
