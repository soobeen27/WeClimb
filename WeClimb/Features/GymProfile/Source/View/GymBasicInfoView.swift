//
//  GymBasicInfoView.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/27/25.
//
import UIKit

import SnapKit
import Kingfisher

class GymBasicInfoView: UIView {
    
    var profileImageURL: URL? {
        didSet {
            guard let url = profileImageURL else { return }
                profileImageView.kf.setImage(with: url)
        }
    }
    var address: String? {
        didSet {
            guard let address else { return }
            addressLabel.text = address
        }
    }
    
    var name: String? {
        didSet {
            guard let name else { return }
            nameLabel.text = name
        }
    }
    
    private let consts = GymConsts.BasicInfoView.self

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = consts.Font.name
        label.textColor = consts.Color.name
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = consts.Font.address
        label.textColor = consts.Color.address
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [profileImageView, nameLabel, addressLabel]
            .forEach { self.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(consts.Size.imageSize)
            $0.top.leading.bottom.equalToSuperview().inset(consts.Size.padding)
        }
        profileImageView.layer.cornerRadius = consts.Size.imageCornerRadius
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(nameLabel)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(consts.Size.imageNameSpacing)
            $0.top.equalTo(addressLabel.snp.bottom).offset(consts.Size.nameAddresssSpacing)
        }
        
    }
}
