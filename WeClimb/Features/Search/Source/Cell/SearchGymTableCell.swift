//
//  SearchGymTableCell.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import Kingfisher
import RxSwift

class SearchGymTableCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    private let gymImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = SearchConst.Color.gymImageDefaultBackground
        imageView.layer.cornerRadius = SearchConst.Shape.cellImageCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let gymLocationLabel: UILabel = {
        let label = UILabel()
        label.font = SearchConst.Font.gymLocationFont
        label.textColor = SearchConst.Color.gymLocationtextColor
        return label
    }()
    
    private let gymNameLabel: UILabel = {
        let label = UILabel()
        label.font = SearchConst.Font.gymNameFont
        label.textColor = SearchConst.Color.gymNameTextColor
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(SearchConst.Text.cellCancelBtnTitle, for: .normal)
        button.setTitleColor(SearchConst.Color.cellCancelBtnTitleColor, for: .normal)
        button.titleLabel?.font = SearchConst.Font.cellCancelBtnFont
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()
    
    var onDelete: ((SearchResultItem) -> Void)?
    
    var shouldShowDeleteButton: Bool = true {
        didSet {
            deleteButton.isHidden = !shouldShowDeleteButton
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    private func setLayout() {
        
        [gymImageView, gymLocationLabel, gymNameLabel, deleteButton]
            .forEach { contentView.addSubview($0) }
        
        gymImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SearchConst.gymCell.Spacing.gymImageleftSpacing)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(SearchConst.gymCell.Size.gymImageSize)
        }
        
        gymLocationLabel.snp.makeConstraints {
            $0.leading.equalTo(gymImageView.snp.trailing).offset(SearchConst.gymCell.Spacing.gymLocationleftSpacing)
            $0.top.equalTo(gymImageView.snp.top)
        }
        
        gymNameLabel.snp.makeConstraints {
            $0.leading.equalTo(gymLocationLabel)
            $0.top.equalTo(gymLocationLabel.snp.bottom).offset(SearchConst.gymCell.Spacing.gymNameTopSpacing)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(SearchConst.gymCell.Spacing.cancelBtnRightSpacing)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: SearchResultItem, searchStyle: SearchStyle) {
        gymNameLabel.text = item.name
        gymLocationLabel.text = item.location
        
        if let imageURL = URL(string: item.imageName), !item.imageName.isEmpty {
            gymImageView.kf.setImage(with: imageURL, placeholder: SearchConst.Image.emptyDefaultImage)
        } else {
            gymImageView.image = SearchConst.Image.emptyDefaultImage
        }
        
        if searchStyle == .uploadSearch || traitCollection.userInterfaceStyle == .dark {
            self.backgroundColor = .fillSolidDarkBlack
            gymNameLabel.textColor = .labelWhite
            gymLocationLabel.textColor = .labelWhite
        } else {
            self.backgroundColor = .white
            gymNameLabel.textColor = .labelStrong
            gymNameLabel.textColor = .labelNeutral
        }
    }
    
    @objc private func didTapDeleteButton() {
        guard let name = gymNameLabel.text else { return }
        let itemToDelete = SearchResultItem(type: .gym, name: name, imageName: "", location: nil, height: nil, armReach: nil)
        onDelete?(itemToDelete)
    }
}

