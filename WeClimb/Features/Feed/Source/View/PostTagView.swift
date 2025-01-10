//
//  PostTagView.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import UIKit

import SnapKit

class PostTagView: UIView {
    var leftImage: UIImage?
    var rightImage: UIImage?
    var text: String?
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = leftImage
        return imageView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = rightImage
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = FeedConts.Profile.Color.text
        label.font = FeedConts.Profile.Font.tag
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
        return CGSize(width: .zero, height: FeedConts.Profile.Size.tagHeight)
    }
    
    func setLayout() {
        self.layer.cornerRadius = FeedConts.Profile.Size.tagCornerRadius
        self.backgroundColor = FeedConts.Profile.Color.tagBackground
    }
}
