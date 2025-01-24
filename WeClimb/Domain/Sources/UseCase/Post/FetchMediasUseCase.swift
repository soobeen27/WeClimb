//
//  FetchMediaUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/21/25.
//

import RxSwift
import FirebaseFirestore

protocol FetchMediasUseCase {
    func execute(refs: [DocumentReference]) -> Single<[Media]>
}

struct FetchMediasUseCaseImpl: FetchMediasUseCase {
    private let fetchMediasRepository: FetchMediasRepository
    
    init(fetchMediasRepository: FetchMediasRepository) {
        self.fetchMediasRepository = fetchMediasRepository
    }
    
    func execute(refs: [DocumentReference]) -> Single<[Media]> {
        return fetchMediasRepository.fetchMedias(refs: refs)
    }
}
