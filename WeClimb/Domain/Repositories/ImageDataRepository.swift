//
//  ImageDataRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import UIKit

import RxSwift

protocol ImageDataRepository {
    func loadImage(from imageURL: String?, imageView: UIImageView)
}
