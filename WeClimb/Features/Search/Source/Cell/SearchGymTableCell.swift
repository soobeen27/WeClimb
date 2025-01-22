//
//  SearchGymTableCell.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import Kingfisher

class SearchGymTableCell: UITableViewCell {
    
    private let gymImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 36 / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let gymLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(style: .caption2Regular)
        label.textColor = .labelNeutral
        return label
    }()
    
    private let gymNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(style: .label2SemiBold)
        label.textColor = .labelStrong
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.labelNeutral, for: .normal)
        button.titleLabel?.font = UIFont.customFont(style: .caption1Regular)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    private func setLayout() {
        
        [gymImageView, gymLocationLabel, gymNameLabel, cancelButton]
            .forEach { contentView.addSubview($0) }
        
        
        gymImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        
        gymLocationLabel.snp.makeConstraints {
            $0.leading.equalTo(gymImageView.snp.trailing).offset(8)
            $0.top.equalTo(gymImageView.snp.top)
        }
        
        gymNameLabel.snp.makeConstraints {
            $0.leading.equalTo(gymLocationLabel)
            $0.top.equalTo(gymLocationLabel.snp.bottom).offset(2)
        }
        
        cancelButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configure(with item: SearchResultItem) {
        gymNameLabel.text = item.name
        gymLocationLabel.text = item.location

        if let imageURL = URL(string: item.imageName), !item.imageName.isEmpty {
            gymImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: ""))
        } else {
            gymImageView.image = UIImage(named: "placeholder_image")
        }
    }


}

