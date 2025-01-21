//
//  ImageDataSource.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation
import FirebaseStorage
import RxSwift

protocol FirebaseImageDataSource {
    func fetchImageURL(from gsURL: String) -> Single<String?>
}

final class FirebaseImageDataSourceImpl: FirebaseImageDataSource {

    private let storage = Storage.storage()

    func fetchImageURL(from gsURL: String) -> Single<String?> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "ImageDataSource", code: -1, userInfo: nil)))
                return Disposables.create()
            }

            let storageReference = self.storage.reference(forURL: gsURL)
            storageReference.downloadURL { url, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                single(.success(url?.absoluteString))
            }

            return Disposables.create()
        }
    }
}
