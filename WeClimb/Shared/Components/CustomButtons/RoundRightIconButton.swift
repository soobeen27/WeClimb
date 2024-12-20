//
//  CustomImageButton.swift
//  WeClimb
//
//  Created by 강유정 on 12/18/24.
//

import UIKit

class RoundRightIconButton: UIButton {
    
    var rightImage: UIImage? {
        didSet {
            updateButtonImages()
        }
    }
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setButton()
        setLayout()
    }
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: RoundRightIconButtonNS.width, height: RoundRightIconButtonNS.height)
    }
    
    private func setButton() {
        titleLabel?.font = UIFont.systemFont(ofSize: RoundRightIconButtonNS.font, weight: .medium)
        layer.cornerRadius = RoundRightIconButtonNS.cornerRadius
        clipsToBounds = true
    }
    
    private func setLayout() {
        guard let titleLabel = titleLabel else { return }
        
        addSubview(rightImageView)
        
        rightImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-RoundRightIconButtonNS.trailing)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(RoundRightIconButtonNS.imageSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.trailing.equalTo(rightImageView.snp.leading).offset(-RoundRightIconButtonNS.inteval)
            $0.leading.equalToSuperview().offset(RoundRightIconButtonNS.leading)
        }
    }
    
    private func updateButtonImages() {
        rightImageView.image = rightImage
    }
}
