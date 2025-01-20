//
//  FetchMediaDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/21/25.
//

import Foundation
import RxSwift
import FirebaseFirestore

protocol FetchMediaDataSource {
    func fetchMedia(ref: DocumentReference) -> Single<Media>
}

class FetchMediaDataSourceImpl: FetchMediaDataSource {
    func fetchMedia(ref: DocumentReference) -> Single<Media> {
        return Single.create { single in
            let db = Firestore.firestore()
            
            ref.getDocument(as: Media.self) { result in
                switch result {
                case .success(let media):
                    single(.success(media))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
