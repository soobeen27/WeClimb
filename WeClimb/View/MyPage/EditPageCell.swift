//
//  EditPageCell.swift
//  WeClimb
//
//  Created by 강유정 on 8/30/24.
//

import UIKit

import RxSwift
import SnapKit

class EditPageCell: UITableViewCell {
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()
    
    private let nextImagView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setColor()
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        leftStackView.addArrangedSubview(titleLabel)
        
        [infoLabel, nextImagView]
            .forEach { rightStackView.addArrangedSubview($0) }
        
        [leftStackView, rightStackView]
            .forEach { contentView.addSubview($0) }
        
        leftStackView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).inset(16)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.lessThanOrEqualTo(rightStackView.snp.leading).offset(-16)
        }
        
        rightStackView.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).inset(16)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(44)
        }
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
    
    func configure(with model: EditModel) {
        titleLabel.text = model.title
        infoLabel.text = model.info
    }
    
}
