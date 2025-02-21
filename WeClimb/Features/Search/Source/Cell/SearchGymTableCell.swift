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
        imageView.backgroundColor = SearchConst.Cell.Color.gymImageDefaultBackground
        imageView.layer.cornerRadius = SearchConst.Cell.Shape.cellImageCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let gymLocationLabel: UILabel = {
        let label = UILabel()
        label.font = SearchConst.Cell.Font.gymLocationFont
        label.textColor = SearchConst.Cell.Color.gymLocationText
        return label
    }()
    
    private let gymNameLabel: UILabel = {
        let label = UILabel()
        label.font = SearchConst.Cell.Font.gymNameFont
        label.textColor = SearchConst.Cell.Color.gymNameText
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(SearchConst.Cell.Text.cellCancelBtnTitle, for: .normal)
        button.setTitleColor(SearchConst.Cell.Color.cellCancelBtnTitleColor, for: .normal)
        button.titleLabel?.font = SearchConst.Cell.Font.cellCancelBtnFont
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()
    
    var onDelete: ((SearchResultItem) -> Void)?
    
    var shouldShowDeleteButton: Bool = true {
        didSet {
            deleteButton.isHidden = !shouldShowDeleteButton
        }
    }
    
    private var currentItem: SearchResultItem?
    private var currentSearchStyle: SearchStyle?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            
            if let currentItem = currentItem, let currentSearchStyle = currentSearchStyle {
                configure(with: currentItem, searchStyle: currentSearchStyle)
            }
        }
    }
    
    private func setLayout() {
        
        [gymImageView, gymLocationLabel, gymNameLabel, deleteButton]
            .forEach { contentView.addSubview($0) }
        
        gymImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SearchConst.Cell.Spacing.gymImageleftSpacing)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(SearchConst.Cell.Size.gymImageSize)
        }
        
        gymLocationLabel.snp.makeConstraints {
            $0.leading.equalTo(gymImageView.snp.trailing).offset(SearchConst.Cell.Spacing.gymLocationleftSpacing)
            $0.top.equalTo(gymImageView.snp.top)
        }
        
        gymNameLabel.snp.makeConstraints {
            $0.leading.equalTo(gymLocationLabel)
            $0.top.equalTo(gymLocationLabel.snp.bottom).offset(SearchConst.Cell.Spacing.gymNameTopSpacing)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(SearchConst.Cell.Spacing.cancelBtnRightSpacing)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: SearchResultItem, searchStyle: SearchStyle) {
        
        currentItem = item
        currentSearchStyle = searchStyle
        
        gymNameLabel.text = item.name
        gymLocationLabel.text = item.location
        
        if let imageURL = URL(string: item.imageName), !item.imageName.isEmpty {
            gymImageView.kf.setImage(with: imageURL, placeholder: SearchConst.Common.Image.emptyDefaultImage)
        } else {
            gymImageView.image = SearchConst.Common.Image.emptyDefaultImage
        }
        
        if searchStyle == .uploadSearch {
            applyDarkModeStyle()
            return
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            applyDarkModeStyle()
        } else {
            applyLightModeStyle()
        }
    }

    private func applyDarkModeStyle() {
        self.backgroundColor = SearchConst.Cell.Color.backgroundDark
        gymNameLabel.textColor = SearchConst.Cell.Color.gymNameTextDark
        gymLocationLabel.textColor = SearchConst.Cell.Color.gymLocationTextDark
    }

    private func applyLightModeStyle() {
        self.backgroundColor = SearchConst.Cell.Color.background
        gymNameLabel.textColor = SearchConst.Cell.Color.gymNameText
        gymLocationLabel.textColor = SearchConst.Cell.Color.gymLocationText
    }
    
    @objc private func didTapDeleteButton() {
        guard let name = gymNameLabel.text else { return }
        let itemToDelete = SearchResultItem(type: .gym, name: name, imageName: "", location: nil, height: nil, armReach: nil)
        onDelete?(itemToDelete)
    }
}

