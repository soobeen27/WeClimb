//
//  FetchMediaRepository.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/21/25.
//

import RxSwift
import FirebaseFirestore

protocol FetchMediaRepository {
    func fetchMedia(ref: DocumentReference) -> Single<Media>
}
