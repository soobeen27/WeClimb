//
//  SelectSettingCell.swift
//  WeClimb
//
//  Created by 강유정 on 11/12/24.
//

import UIKit

import SnapKit

class SelectSettingCell: UICollectionViewCell {
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 23
        layer.borderColor = UIColor.lightGray.cgColor
//        layer.borderWidth = 1.0
        clipsToBounds = true
        
        setLayout()
        setColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        colorView.backgroundColor = .clear
        colorView.layer.contents = nil
        titleLabel.text = nil
        layer.borderWidth = 0
    }
    
    private func setLayout() {
        [colorView, titleLabel]
            .forEach {
                contentView.addSubview($0)
            }
        
        colorView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(colorView)
            $0.trailing.equalToSuperview().offset(-12)
        }
    }
    
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
    
    override var isSelected: Bool {
        didSet {
            updateSelectionButton()
        }
    }
    
    private func updateSelectionButton() {
        if isSelected {
            layer.borderColor = UIColor.mainPurple.cgColor
            layer.borderWidth = 1
        } else {
            layer.borderWidth = 0
        }
    }

    func configure(item: Any) {
        
        if let grade = item as? String {
            
            titleLabel.text = grade.colorInfo.text
            let colorInfo = grade.colorInfo
            colorView.backgroundColor = colorInfo.color
            
        } else if let hold = item as? Hold {
            
            titleLabel.text = hold.koreanHold
            if let image = hold.image() {
                colorView.layer.contents = image.cgImage
            }
        }
    }
}
