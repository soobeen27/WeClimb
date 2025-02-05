//
//  MediaRemoteDataSource.swift
//  WeClimb
//
//  Created by 윤대성 on 2/5/25.
//

import Foundation

import FirebaseFirestore
import RxSwift

protocol MediaRemoteDataSource {
    func fetchHolds(for postUID: String) -> Single<[String]>
}

final class MediaRemoteDataSourceImpl: MediaRemoteDataSource {
    private let db = Firestore.firestore()
    
    func fetchHolds(for postUID: String) -> Single<[String]> {
        return Single.create { single in
            let postRef = self.db.collection("posts").document(postUID)
            
            postRef.getDocument { snapshot, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = snapshot?.data(),
                      let mediaRefs = data["medias"] as? [DocumentReference] else {
                    single(.success([])) // medias 필드가 없으면 빈 배열 반환
                    return
                }
                
                let holdsFetchObservables = mediaRefs.map { mediaRef in
                    return Single<String>.create { single in
                        mediaRef.getDocument { mediaSnapshot, error in
                            if let error = error {
                                single(.failure(error))
                                return
                            }
                            let hold = mediaSnapshot?.data()?["hold"] as? String ?? ""
                            single(.success(hold))
                        }
                        return Disposables.create()
                    }
                }
                
                Single.zip(holdsFetchObservables)
                    .subscribe(single)
                    .disposed(by: DisposeBag())
            }
            
            return Disposables.create()
        }
    }
}
