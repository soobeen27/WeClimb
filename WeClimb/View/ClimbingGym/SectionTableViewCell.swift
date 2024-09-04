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
        label.textColor = .label
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .mainPurple // 프로그래스 바의 색상
        progressView.trackTintColor = .blue // 트랙의 색상
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        return progressView
    }()
    
    private let itemCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
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
        self.backgroundColor = UIColor(named: "BackgroundColor") ?? .white
        
        [
            sectorLabel,
            progressBar,
            itemCountLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayout() {
        sectorLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
        }
        
        progressBar.snp.makeConstraints {
            $0.leading.equalTo(sectorLabel.snp.trailing).offset(16)
            $0.centerY.equalTo(sectorLabel.snp.centerY)
            $0.height.equalTo(8)
        }
        
        itemCountLabel.snp.makeConstraints {
            $0.leading.equalTo(progressBar.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(progressBar.snp.centerY)
        }
        
        progressBar.snp.makeConstraints {
            $0.trailing.equalTo(itemCountLabel.snp.leading).offset(-16)
        }
    }
    
    func configure(with item: Item, completedCount: Int, totalCount: Int) {
        sectorLabel.text = item.name
        let progress = Float(completedCount) / Float(totalCount)
        progressBar.progress = progress
        itemCountLabel.text = "\(completedCount)/\(totalCount)"
    }
}


