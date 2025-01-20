//
//  FetchMediaUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/21/25.
//

import RxSwift
import FirebaseFirestore

protocol FetchMediaUseCase {
    func execute(ref: DocumentReference) -> Single<Media>
}

struct FetchMediaUseCaseImpl: FetchMediaUseCase {
    private let fetchMediaRepository: FetchMediaRepository
    
    init(fetchMediaRepository: FetchMediaRepository) {
        self.fetchMediaRepository = fetchMediaRepository
    }
    
    func execute(ref: DocumentReference) -> Single<Media> {
        return fetchMediaRepository.fetchMedia(ref: ref)
    }
}
