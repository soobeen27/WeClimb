//
//  PostProfileView.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import UIKit

import SnapKit
import RxSwift

class PostProfileView: UIView {
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = FeedConsts.Profile.Size.profileImageCornerRadius
        return imageView
    }()
    
    
    
}
