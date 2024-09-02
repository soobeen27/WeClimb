//
//  SectionDetailTableViewCell.swift
//  WeClimb
//
//  Created by 머성이 on 8/30/24.
//

import UIKit

import SnapKit

class SectionDetailTableViewCell: UITableViewCell {
    
    private let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 1
        return label
    }()
    
    private let videoCountLabel: UILabel = {
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
        self.backgroundColor = .lightGray
        
        [detailImageView, detailLabel, videoCountLabel].forEach { addSubview($0) }
    }
    
    private func setLayout() {
        detailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(8)
            $0.width.equalTo(80)
            $0.height.equalTo(80)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        detailLabel.snp.makeConstraints {
            $0.leading.equalTo(detailImageView.snp.trailing).offset(16)
            $0.top.equalTo(detailImageView.snp.top)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        videoCountLabel.snp.makeConstraints {
            $0.leading.equalTo(detailLabel.snp.leading)
            $0.top.equalTo(detailLabel.snp.bottom).offset(4)
            $0.trailing.equalTo(detailLabel.snp.trailing)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(with item: DetailItem) {
        detailImageView.image = item.image
        detailLabel.text = item.description
        videoCountLabel.text = "영상 \(item.videoCount)개"
        
        // 예시로 하나의 텍스트를 강조하는 스타일
        if let text = videoCountLabel.text {
            let attributedString = NSMutableAttributedString(string: text)
            if let range = text.range(of: "영상 1N개") {
                let nsRange = NSRange(range, in: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: nsRange)
            }
            videoCountLabel.attributedText = attributedString
        }
    }
}
