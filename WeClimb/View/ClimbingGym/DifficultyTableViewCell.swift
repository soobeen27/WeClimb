//
//  gradeTableViewCell.swift
//  WeClimb
//
//  Created by 머성이 on 8/26/24.
//

import UIKit

import SnapKit

class gradeTableViewCell: UITableViewCell {
    
    private let gradeColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let gradeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .label
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [
            gradeColorView,
            gradeLabel,
            arrowImageView
        ].forEach { contentView.addSubview($0) }
        
        gradeColorView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        gradeLabel.snp.makeConstraints {
            $0.leading.equalTo(gradeColorView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with color: UIColor, grade: String) {
        gradeColorView.backgroundColor = color
        let convertedGrade = grade.colorTextChange()
        gradeLabel.text = "\(convertedGrade) 문제"
    }
}
