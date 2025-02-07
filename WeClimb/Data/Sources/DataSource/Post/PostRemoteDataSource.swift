//
//  PostRemoteDataSource.swift
//  WeClimb
//
//  Created by 윤대성 on 2/5/25.
//

import Foundation

import FirebaseFirestore
import RxSwift

protocol PostRemoteDataSource {
    func fetchUserPosts(userUID: String) -> Single<[Post]>
}

final class PostRemoteDataSourceImpl: PostRemoteDataSource {
    private let db = Firestore.firestore()
    
    func fetchUserPosts(userUID: String) -> Single<[Post]> {
        return Single.deferred {
            let postsRef = self.db.collection("posts")
            
            return Single<[Post]>.create { single in
                postsRef.whereField("authorUID", isEqualTo: userUID)
                    .order(by: "creationDate", descending: true)
                    .getDocuments { snapshot, error in
                        if let error = error {
                            print("❌ Firestore Fetch Error: \(error.localizedDescription)")
                            single(.failure(error))
                            return
                        }
                        
                        guard let documents = snapshot?.documents, !documents.isEmpty else {
                            print("⚠️ Firestore 데이터 없음! userUID: \(userUID)")
                            single(.success([]))
                            return
                        }
                        
                        do {
                            let posts: [Post] = try documents.compactMap { doc in
                                return try doc.data(as: Post.self)
                            }
//                            print("✅ Firestore에서 가져온 포스트 개수: \(posts.count)")
                            single(.success(posts))
                        } catch {
                            print("❌ 데이터 변환 오류: \(error.localizedDescription)")
                            single(.failure(error))
                        }
                    }
                
                return Disposables.create()
            }
        }
    }
}
