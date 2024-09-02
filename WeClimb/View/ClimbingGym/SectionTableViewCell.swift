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
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .blue
        return progressView
    }()
    
    private let itemCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
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
        self.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [
            sectorLabel,
            progressBar,
            itemCountLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayout() {
        sectorLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        progressBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(sectorLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        itemCountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(progressBar.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(with item: Item, progress: Float, itemCount: Int) {
        sectorLabel.text = item.name
        progressBar.progress = progress
        itemCountLabel.text = "\(itemCount) items"
    }
}
