//
//  ImageDataRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import UIKit

import RxSwift

final class ImageDataRepositoryImpl: ImageDataRepository {
    private let imageDataSource: ImageDataSource
    
    init(imageDataSource: ImageDataSource) {
        self.imageDataSource = imageDataSource
    }
    
    func loadImage(from imageURL: String?, imageView: UIImageView) {
        return imageDataSource.loadImage(from: imageURL, imageView: imageView)
    }
}
