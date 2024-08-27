//
//  ClimbingTableViewCell.swift
//  WeClimb
//
//  Created by 머성이 on 8/26/24.
//

import UIKit

import SnapKit

class SectionTableViewCell: UITableViewCell {
    
    private let gymLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
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
            gymLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayout() {
        gymLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
}
