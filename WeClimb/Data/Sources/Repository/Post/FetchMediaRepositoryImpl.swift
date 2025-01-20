//
//  FetchMediaRepositoryImpl.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/21/25.
//

import RxSwift
import FirebaseFirestore

class FetchMediaRepositoryImpl: FetchMediaRepository {
    private let fetchMediaDataSource: FetchMediaDataSource
    
    init(fetchMediaDataSource: FetchMediaDataSource) {
        self.fetchMediaDataSource = fetchMediaDataSource
    }
    
    func fetchMedia(ref: DocumentReference) -> Single<Media> {
        return fetchMediaDataSource.fetchMedia(ref: ref)
    }
}
