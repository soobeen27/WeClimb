//
//  PostTagView.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import UIKit

import SnapKit

class PostTagView: UIView {
    var leftImage: UIImage? {
        didSet {
            leftImageView.image = leftImage
            setLayout()
        }
    }
    var rightImage: UIImage? {
        didSet {
            rightImageView.image = rightImage
            setLayout()
        }
    }
    var text: String? {
        didSet {
            textLabel.text = text
            setLayout()
        }
    }
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = FeedConsts.Profile.Color.text
        label.font = FeedConsts.Profile.Font.tag
        label.text = text
        return label
    }()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: .zero, height: FeedConsts.Profile.Size.tagHeight)
    }
    
    func setLayout() {
        self.layer.cornerRadius = FeedConsts.Profile.Size.tagCornerRadius
        self.backgroundColor = FeedConsts.Profile.Color.tagBackground
        
        if let leftImage {
            [leftImageView, textLabel]
                .forEach {
                    self.addSubview($0)
                }
            leftImageView.image =
            leftImage.resize(targetSize: FeedConsts.Profile.Size.tagImage)
            
            leftImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(FeedConsts.Profile.Size.tagHPadding)
                $0.centerY.equalToSuperview()
            }
            textLabel.snp.makeConstraints {
                $0.leading.equalTo(leftImageView.snp.trailing).offset(FeedConsts.Profile.Size.tagSpacing)
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-FeedConsts.Profile.Size.tagHPadding)
            }
        } else if let rightImage {
            [rightImageView, textLabel]
                .forEach {
                    self.addSubview($0)
                }
            
            rightImageView.image =
            rightImage.resize(targetSize: FeedConsts.Profile.Size.tagImage)
            
            rightImageView.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-FeedConsts.Profile.Size.tagHPadding)
                $0.centerY.equalToSuperview()
            }
            textLabel.snp.makeConstraints {
                $0.trailing.equalTo(rightImageView.snp.leading).offset(-FeedConsts.Profile.Size.tagSpacing)
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(FeedConsts.Profile.Size.tagHPadding)
            }
        }
    }
}
