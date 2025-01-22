//
//  FetchMediaDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/21/25.
//

import Foundation
import RxSwift
import FirebaseFirestore

protocol FetchMediasDataSource {
    func fetchMedias(refs: [DocumentReference]) -> Single<[Media]>
}

class FetchMediasDataSourceImpl: FetchMediasDataSource {

    func fetchMedias(refs: [DocumentReference]) -> Single<[Media]> {
        return Single.create { single in
            let db = Firestore.firestore()
            Task {
                do {
                    var medias: [Media] = []
                    
                    guard !refs.isEmpty else {
                        single(.success(medias))
                        return
                    }
                    
                    let batchQuery = try await db.getAllDocuments(from: refs)
                    
                    let mediaDict: [String: Media] = batchQuery.compactMap { document in
                        if let media = try? document.data(as: Media.self) {
                            return (document.documentID, media)
                        } else {
                            return nil
                        }
                    }.reduce(into: [:]) { dict, item in
                        dict[item.0] = item.1
                    }
                    
                    medias = refs.compactMap { ref in
                        mediaDict[ref.documentID]
                    }
                    
                    single(.success(medias))
                } catch {
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
