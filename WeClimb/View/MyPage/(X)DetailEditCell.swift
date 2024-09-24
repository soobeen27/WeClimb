//
//  DetailEditCell.swift
//  WeClimb
//
//  Created by 강유정 on 9/1/24.
//

import UIKit

import RxSwift
import SnapKit

class DetailEditCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .label
        label.text = "이름"
        return label
    }()
    
    private let infoTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = .clear
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setColor()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 커스텀 색상 YJ
    private func setColor() {
        contentView.backgroundColor = UIColor {
            switch $0.userInterfaceStyle {
            case .dark:
                return UIColor.secondarySystemBackground
            default:
                return UIColor.white
            }
        }
    }
    
    private func setLayout() {
        [titleLabel, infoTextField]
            .forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).inset(16)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.equalTo(100)
        }
        
        infoTextField.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).inset(16)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(30)
        }
    }
    
    func configure(with model: EditModel) {
        titleLabel.text = model.title
        infoTextField.text = model.info
    }
}
