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
//        print("🚀 fetchHolds 실행됨 - postUID: \(postUID)")
        
        let postRef = self.db.collection("posts").document(postUID)
        
        return Single<DocumentSnapshot>.create { single in
            postRef.getDocument { snapshot, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let snapshot = snapshot, let data = snapshot.data(),
                      let mediaRefs = data["medias"] as? [DocumentReference], !mediaRefs.isEmpty else {
//                    print("⚠️ fetchHolds: medias 필드 없음, postUID: \(postUID)")
                    single(.success(snapshot!)) // ✅ 빈 스냅샷 반환
                    return
                }
                
                single(.success(snapshot))
            }
            return Disposables.create()
        }
        .flatMap { snapshot -> Single<[String]> in
            guard let data = snapshot.data(),
                  let mediaRefs = data["medias"] as? [DocumentReference], !mediaRefs.isEmpty else {
                return Single.just([])
            }
            
            let holdsFetchObservables = mediaRefs.map { mediaRef in
                return Single<String>.create { single in
//                    print("🚀 Media fetch 실행 - mediaRef: \(mediaRef.path)")
                    mediaRef.getDocument { mediaSnapshot, error in
                        if let error = error {
                            single(.failure(error))
                            return
                        }
                        let hold = mediaSnapshot?.data()?["hold"] as? String ?? ""
//                        print("✅ 가져온 hold 데이터: \(hold), mediaRef: \(mediaRef.path)")
                        single(.success(hold))
                    }
                    return Disposables.create()
                }
            }
            
//            print("🔄 holdsFetchObservables 개수: \(holdsFetchObservables.count)")
            return Single.zip(holdsFetchObservables)
        }
        .do(onSubscribe: {
            print("⚡ fetchHolds subscribe 호출됨")
        })
        .do(onSuccess: { holds in
            print("✅ fetchHolds 최종 반환: \(holds.count)개 hold 데이터")
        })
    }
}
