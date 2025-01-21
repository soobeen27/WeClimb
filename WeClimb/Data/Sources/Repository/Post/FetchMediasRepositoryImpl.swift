//
//  FetchMediaRepositoryImpl.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/21/25.
//

import RxSwift
import FirebaseFirestore

class FetchMediasRepositoryImpl: FetchMediasRepository {
    private let fetchMediasDataSource: FetchMediasDataSource
    
    init(fetchMediasDataSource: FetchMediasDataSource) {
        self.fetchMediasDataSource = fetchMediasDataSource
    }
    
    func fetchMedias(refs: [DocumentReference]) -> Single<[Media]> {
        return fetchMediasDataSource.fetchMedias(refs: refs)
    }
}
