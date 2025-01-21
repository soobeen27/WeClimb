//
//  ImageDataSource.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import UIKit

import FirebaseStorage
import Kingfisher
import RxSwift

protocol ImageDataSource {
    func loadImage(from imageURL: String?, imageView: UIImageView)
}

final class ImageDataSourceImpl: ImageDataSource {
    private let storage = Storage.storage()
    private let urlCache = NSCache<NSString, NSURL>()
    private let imageCache = NSCache<NSString, UIImage>()
    private var ongoingRequests: [String: Bool] = [:] // 중복 요청 방지 및 캐시 관리
    
    private func fetchImageURL(from gsURL: String) -> Single<URL?> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "파베 이미지 데이터소스", code: -1, userInfo: nil)))
                return Disposables.create()
            }
            
            if let cachedURL = self.urlCache.object(forKey: gsURL as NSString) {
                single(.success(cachedURL as URL))
                return Disposables.create()
            }
            
            guard self.ongoingRequests[gsURL] == nil else {
                single(.success(nil))
                return Disposables.create()
            }
            
            self.ongoingRequests[gsURL] = true
            
            let storageReference = self.storage.reference(forURL: gsURL)
            storageReference.downloadURL { [weak self] url, error in
                guard let self = self else { return }
                self.ongoingRequests[gsURL] = nil
                
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                if let url = url {
                    self.urlCache.setObject(url as NSURL, forKey: gsURL as NSString)
                }
                single(.success(url))
            }
            
            return Disposables.create()
        }
    }
    
    func loadImage(from imageURL: String?, imageView: UIImageView) {
        guard let imageUrl = imageURL else {
            imageView.image = UIImage(named: "defaultImage")
            return
        }
        
        if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
            imageView.image = cachedImage
            return
        }
        
        if imageUrl.hasPrefix("gs://") {
            fetchImageURL(from: imageUrl)
                .subscribe(onSuccess: { [weak self] httpsURL in
                    guard let self = self, let httpsURL = httpsURL else {
                        imageView.image = UIImage(named: "defaultImage")
                        return
                    }
                    self.setImage(with: httpsURL, into: imageView, cacheKey: imageUrl)
                }, onFailure: { error in
                    print("Failed to fetch image URL: \(error.localizedDescription)")
                    imageView.image = UIImage(named: "defaultImage")
                })
                .disposed(by: DisposeBag())
        } else {
            guard let url = URL(string: imageUrl) else {
                imageView.image = UIImage(named: "defaultImage")
                return
            }
            setImage(with: url, into: imageView, cacheKey: imageUrl)
        }
    }
    
    private func setImage(with url: URL?, into imageView: UIImageView, cacheKey: String) {
        let options: KingfisherOptionsInfo = [
            .transition(.fade(0.2)),
            .cacheOriginalImage
        ]
        
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"), options: options) { [weak self] result in
            switch result {
            case .success(let value):
                self?.imageCache.setObject(value.image, forKey: cacheKey as NSString)
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
}
