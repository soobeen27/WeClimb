//
//  Untitled.swift
//  WeClimb
//
//  Created by 강유정 on 1/13/25.
//

import Foundation

import RxSwift

protocol FetchImageURLUseCase {
    func execute(from gsURL: String) -> Single<String?>
}

class FetchImageURLUseCaseImpl: FetchImageURLUseCase {

    private let firebaseimageRepository: FirebaseImageRepository

    init(firebaseimageRepository: FirebaseImageRepository) {
        self.firebaseimageRepository = firebaseimageRepository
    }

    func execute(from gsURL: String) -> Single<String?> {
        return firebaseimageRepository.fetchImageURL(from: gsURL)
    }
}

