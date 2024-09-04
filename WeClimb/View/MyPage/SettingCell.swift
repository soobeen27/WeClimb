//
//  SettingCell.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import UIKit
import SnapKit

class SettingCell: UITableViewCell {
   
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.top.bottom.equalTo(contentView).inset(16)
        }
    }
    
    func configure(with item: SettingItem) {
        titleLabel.text = item.title
    }
}
