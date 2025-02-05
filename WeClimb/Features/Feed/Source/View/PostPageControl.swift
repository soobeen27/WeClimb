//
//  PostPageControl.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/5/25.
//


import UIKit
import SnapKit

class PostPageControl: UIView {
    private let const = FeedConsts.pageControl.self
    
    var currentPageCount: Int = 0 {
        didSet {
            currentPageCountLabel.text = "\(currentPageCount)"
        }
    }
    
    var totalPageCount: Int = 0 {
        didSet {
            totalPageCountLabel.text = "\(totalPageCount)"
        }
    }
    
    private lazy var currentPageCountLabel: UILabel = {
        let label = UILabel()
        label.font = const.Font.text
        label.textColor = const.Color.text
        label.text = "0"
        return label
    }()
    
    private lazy var slashLabel: UILabel = {
        let label = UILabel()
        label.font = const.Font.slash
        label.textColor = const.Color.slash
        label.text = const.Text.slash
        return label
    }()
    
    private lazy var totalPageCountLabel: UILabel = {
        let label = UILabel()
        label.font = const.Font.text
        label.textColor = const.Color.text
        label.text = "0"
        return label
    }()
    
    private lazy var textSTV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [currentPageCountLabel, slashLabel, totalPageCountLabel])
        sv.axis = .horizontal
        sv.spacing = const.Size.spacing
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = const.Color.background
        self.layer.cornerRadius = const.Size.cornerRadius
        self.clipsToBounds = true
        
        self.addSubview(textSTV)
        
        textSTV.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(const.Size.vPadding)
            $0.trailing.leading.equalToSuperview().inset(const.Size.hPadding)
        }
    }
}
