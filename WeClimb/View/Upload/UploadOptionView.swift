//
//  UploadOptionView.swift
//  WeClimb
//
//  Created by Soo Jang on 8/28/24.
//

import UIKit

import SnapKit

class UploadOptionView : UIView {
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "figure.climbing")
        imageView.tintColor = .label
        return imageView
    }()
    
    var optionLabel: UILabel = {
        let label = UILabel()
//        label.text = UploadNameSpace.selectGym
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    let selectedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = UploadNameSpace.select
        label.textColor = .secondaryLabel
        label.textAlignment = .right
//        label.isHidden = true
        return label
    }()
    
    let nextImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
//        imageView.isHidden = true
        return imageView
    }()
    
    private let separatorLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .secondarySystemBackground
        return label
    }()
    
    private var showSelectedLabel: Bool
    
    init(symbolImage: UIImage, optionText: String, showSelectedLabel: Bool = true) {
        self.showSelectedLabel = showSelectedLabel
        super.init(frame: .zero)
        symbolImageView.image = symbolImage
        optionLabel.text = optionText
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 57)
    }

    private func setLayout() {
        self.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [symbolImageView, separatorLine, optionLabel]
            .forEach { self.addSubview($0) }
        
        separatorLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        symbolImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(16)
        }
        
        optionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(symbolImageView.snp.trailing).offset(8)
        }
        
        if !showSelectedLabel {
            [selectedLabel, nextImageView]
                .forEach { self.addSubview($0) }
            
            selectedLabel.snp.makeConstraints {
                $0.trailing.equalTo(nextImageView.snp.leading).offset(-8)
                $0.centerY.equalToSuperview()
            }
            
            nextImageView.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-16)
                $0.centerY.equalToSuperview()
            }
        }
    }
}
