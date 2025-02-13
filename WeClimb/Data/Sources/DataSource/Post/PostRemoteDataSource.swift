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
            let userRef = self.db.collection("users").document(userUID)
            
            return Single<[Post]>.create { single in
                userRef.getDocument { snapshot, error in
                    if let error = error {
                        print("❌ Firestore Fetch Error: \(error.localizedDescription)")
                        single(.failure(error))
                        return
                    }
                    
                    guard let data = snapshot?.data(),
                          let postRefs = data["posts"] as? [DocumentReference], !postRefs.isEmpty else {
                        print("⚠️ Firestore 데이터 없음! userUID: \(userUID)")
                        single(.success([]))
                        return
                    }
                    
//                    print("✅ 가져온 posts reference 개수: \(postRefs.count)")
                    
                    let postFetchObservables = postRefs.map { ref in
                        return Single<Post>.create { single in
                            ref.getDocument { postSnapshot, error in
                                if let error = error {
                                    single(.failure(error))
                                    return
                                }
                                guard let postData = postSnapshot?.data() else {
                                    single(.failure(NSError(domain: "FirestoreError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Post 데이터 없음"])))
                                    return
                                }
                                do {
                                    let post = try postSnapshot?.data(as: Post.self)
//                                    print("✅ 가져온 포스트: \(post?.postUID ?? "N/A")")
                                    single(.success(post!))
                                } catch {
                                    single(.failure(error))
                                }
                            }
                            return Disposables.create()
                        }
                    }
                    
                    Single.zip(postFetchObservables)
                        .map { posts in
                            return posts.sorted { $0.creationDate > $1.creationDate }
                        }
                        .subscribe(single)
                        .disposed(by: DisposeBag())
                }
                
                return Disposables.create()
            }
        }
    }
}
