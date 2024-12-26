//
//  CollectTableSegment.swift
//  WeClimb
//
//  Created by 강유정 on 12/23/24.
//

import UIKit
import SnapKit

class TableCollectionSegment: UIControl {
    
    var selectedIndex: Int = TableCollectionSegmentNS.startIndex {
        didSet {
            updateSelection()
        }
    }

    private var buttons: [UIButton] = []
    
    private lazy var CollectionButton: UIButton = {
        let button = UIButton()

        if let LeftImage = UIImage(named: "collectionIcon")?.resize(targetSize: CGSize(width: TableCollectionSegmentNS.imageSize, height: TableCollectionSegmentNS.imageSize)) {
             button.setImage(LeftImage, for: .normal)
         }
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 6)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        buttons.append(button)
        return button
    }()
    
    private lazy var TableButton: UIButton = {
        let button = UIButton()
        if let rightImage = UIImage(named: "tableIcon")?.resize(targetSize: CGSize(width: TableCollectionSegmentNS.imageSize, height: TableCollectionSegmentNS.imageSize)) {
             button.setImage(rightImage, for: .normal)
         }
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 10)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.addSubview(button)
        buttons.append(button)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setSegment()
        setLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: TableCollectionSegmentNS.segmentWidth, height: TableCollectionSegmentNS.segmentHeight)
    }

    private func setSegment() {
        self.layer.cornerRadius = TableCollectionSegmentNS.cornerRadius
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.segmentlightGray

        self.layer.borderWidth = TableCollectionSegmentNS.borderWidth
        self.layer.borderColor = UIColor.segmentlightGray.cgColor

        selectedIndex = TableCollectionSegmentNS.startIndex
    }

    private func setLayout() {
        CollectionButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(TableCollectionSegmentNS.buttonSize)
        }
        
        TableButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(TableCollectionSegmentNS.buttonSize)
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        if let index = buttons.firstIndex(of: sender) {
            selectedIndex = index
            sendActions(for: .valueChanged)
        }
    }

    private func updateSelection() {
        for (index, button) in buttons.enumerated() {
            button.isSelected = (index == selectedIndex)

            if button.isSelected {
                button.setImage(button.image(for: .normal)?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
                button.backgroundColor = UIColor.segmentMediumGray
            } else {
                button.setImage(button.image(for: .normal)?.withTintColor(UIColor.segmentGray, renderingMode: .alwaysOriginal), for: .normal)
                button.backgroundColor = .white
            }
        }
    }
}
