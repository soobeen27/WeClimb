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
        return Single.create { single in
            let postsRef = self.db.collection("posts")
            
            postsRef.whereField("authorUID", isEqualTo: userUID)
                .order(by: "creationDate", descending: true)
                .getDocuments { snapshot, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        single(.success([]))
                        return
                    }
                    
                    do {
                        let posts: [Post] = try documents.compactMap { doc in
                            return try doc.data(as: Post.self)
                        }
                        single(.success(posts))
                    } catch {
                        single(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
}
