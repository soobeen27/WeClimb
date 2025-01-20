//
//  ImageDataRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

final class FirebaseImageRepositoryImpl: FirebaseImageRepository {

    private let firebaseImageDataSource: FirebaseImageDataSource

    init(firebaseImageDataSource: FirebaseImageDataSource) {
        self.firebaseImageDataSource = firebaseImageDataSource
    }

    func fetchImageURL(from gsURL: String) -> Single<String?> {
        return firebaseImageDataSource.fetchImageURL(from: gsURL)
    }
}

