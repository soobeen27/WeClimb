//
//  EditPageTabelCell.swift
//  WeClimb
//
//  Created by 김솔비 on 9/12/24.
//

import UIKit

import RxSwift
import SnapKit

class EditPageTableCell: UITableViewCell {
    
    private let profileItemLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private let userInputTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [profileItemLabel, userInputTextField]
            .forEach {
                contentView.addSubview($0)
            }
        
        profileItemLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 50))
            $0.verticalEdges.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().inset(16)
        }
        userInputTextField.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 150, height: 50))
            $0.verticalEdges.equalToSuperview().offset(10)
            $0.leading.equalTo(profileItemLabel.snp.trailing).offset(20)
        }
    }
    
    //MARK: - configure
    func configure(profileItem: String) {
        profileItemLabel.text = profileItem
    }
}
