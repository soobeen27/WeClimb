//
//  ClimbingTableViewCell.swift
//  WeClimb
//
//  Created by 머성이 on 8/26/24.
//

import UIKit

import SnapKit

class SectionTableViewCell: UITableViewCell {
    
    private let sectorLabel: UILabel = {
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
        self.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [
            sectorLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayout() {
        
        sectorLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}


//private let sectorImageView: UIImageView = {
//    let imageView = UIImageView()
//    imageView.contentMode = .scaleAspectFill
//    imageView.clipsToBounds = true
//    imageView.layer.cornerRadius = 8
//    return imageView
//}()
