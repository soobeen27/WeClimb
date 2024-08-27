//
//  CaptionCell.swift
//  WeClimb
//
//  Created by Soo Jang on 8/27/24.
//

import UIKit

import SnapKit

class CaptionCell : UITableViewCell {
    private let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private let textFieldPlaceholder: UILabel = {
        let label = UILabel()
        label.text = UploadNameSpace.placeholder
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
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
        self.backgroundColor = .systemBackground
        [textField, textFieldPlaceholder]
            .forEach {
                self.addSubview($0)
            }
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        textFieldPlaceholder.snp.makeConstraints {
            $0.top.equalTo(textField.snp.top).offset(8)
            $0.leading.equalTo(textField.snp.leading).offset(16)
        }
    }
    
}
