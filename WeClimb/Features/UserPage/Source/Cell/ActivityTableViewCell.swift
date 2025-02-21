//
//  ActivityTableViewCell.swift
//  WeClimb
//
//  Created by 윤대성 on 2/20/25.
//

import UIKit

import SnapKit

class ActivityTableViewCell: UITableViewCell {
    static let identifier = "ActivityTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ProfileSettingConst.Text.homeGym
        label.font = ProfileSettingConst.Font.basicFont
        label.textColor = ProfileSettingConst.Color.basicLabelColor
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = ProfileSettingConst.Text.selectionButtonLabel
        label.font = ProfileSettingConst.Font.cellValueFont
        label.textColor = ProfileSettingConst.Color.valueLabelColor
        return label
    }()
    
    private let chevronRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ProfileSettingConst.Image.chevronRightImage
        return imageView
    }()
    
    private let valueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .center
        return stackView
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
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
            valueLabel,
            chevronRightImageView
        ].forEach { valueStackView.addArrangedSubview($0) }
        
        [
            titleLabel,
            valueStackView
        ].forEach { containerStackView.addArrangedSubview($0) }
        
        [
            containerStackView
        ].forEach { self.addSubview($0) }
        
        containerStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
