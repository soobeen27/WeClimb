//
//  NotificationSettingTableCell.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/20/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class NotificationSettingTableCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let rightSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.onTintColor = .systemGreen
        return switchView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configure(title: String, isOn: Bool) {
        leftLabel.text = title
        rightSwitch.isOn = isOn
    }
    
    private func setLayout() {
        self.contentView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black

        [leftLabel, rightSwitch]
            .forEach {
                self.contentView.addSubview($0)
            }
        leftLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(16)
        }
        
        rightSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.bottom.equalToSuperview().inset(16)
        }
    }
}
