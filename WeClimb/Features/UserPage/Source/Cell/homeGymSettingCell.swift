//
//  homeGymSettingCell.swift
//  WeClimb
//
//  Created by 윤대성 on 2/23/25.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit

class homeGymSettingCell: UITableViewCell {
    static let identifier = "homeGymSettingCell"
    
    private let disposeBag = DisposeBag()
    
    private let gymImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = SearchConst.Color.gymImageDefaultBackground
        imageView.layer.cornerRadius = SearchConst.Shape.cellImageCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let gymLocationLabel: UILabel = {
        let label = UILabel()
        label.font = SearchConst.Font.gymLocationFont
        label.textColor = SearchConst.Color.gymLocationtextColor
        return label
    }()
    
    private let gymNameLabel: UILabel = {
        let label = UILabel()
        label.font = SearchConst.Font.gymNameFont
        label.textColor = SearchConst.Color.gymNameTextColor
        return label
    }()
    
    private let homeGymMarkImage: UIImageView = {
        let img = UIImageView()
        img.image = homeGymSettingConst.Image.nomalHomeGymMark
        img.clipsToBounds = true
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [
            gymImageView,
            gymLocationLabel,
            gymNameLabel,
            homeGymMarkImage,
        ].forEach { self.addSubview($0) }
        
        gymImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SearchConst.gymCell.Spacing.gymImageleftSpacing)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(SearchConst.gymCell.Size.gymImageSize)
        }
        
        gymLocationLabel.snp.makeConstraints {
            $0.leading.equalTo(gymImageView.snp.trailing).offset(SearchConst.gymCell.Spacing.gymLocationleftSpacing)
            $0.top.equalTo(gymImageView.snp.top)
        }
        
        gymNameLabel.snp.makeConstraints {
            $0.leading.equalTo(gymLocationLabel)
            $0.top.equalTo(gymLocationLabel.snp.bottom).offset(SearchConst.gymCell.Spacing.gymNameTopSpacing)
        }
        
        homeGymMarkImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
}
