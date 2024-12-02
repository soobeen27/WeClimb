//
//  MainFeedDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/2/24.
//

import Foundation
import RxSwift
import Firebase

enum FirebaseError: Error {
    case documentNil
    
    var description: String {
        switch self {
        case .documentNil:
            "도큐멘트가 없음"
        default:
            "unknown"
        }
    }
}

protocol MainFeedDataSource {
    
}

class MainFeedDataSourceImpl {
    private let db = Firestore.firestore()
    private var lastFeed: QueryDocumentSnapshot?
    private let disposeBag = DisposeBag()
    
    // MARK: 피드가져오기 (처음 실행되어야할 메소드)
    func getFeed(user: User? = nil) -> Single<[Post]> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CommonError.selfNil))
                return Disposables.create()
            }
            var postRef = self.getPostRef()
            if let user {
                if let blackList = user.blackList, !blackList.isEmpty {
                    postRef = postRef
                        .whereField("authorUID", notIn: blackList)
                }
            }
            self.getPost(postRef: postRef)
                .subscribe(onSuccess: { posts in
                    single(.success(posts))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    
    
    private func getPostRef() -> Query {
        var postsRef = db.collection("posts").order(by: "creationDate", descending: true).limit(to: 50)
        
        if let lastFeed {
            postsRef = postsRef.start(afterDocument: lastFeed)
        }
        return postsRef
    }
    
//    private func checkBlackList
        
    private func getPost(postRef: Query) -> Single<[Post]> {
        return Single.create { single in
            postRef.getDocuments { [weak self] snapshot, error in
                guard let self else { return }
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let documents = snapshot?.documents else {
                    single(.failure(FirebaseError.documentNil))
                    return
                }
                if let lastDocument = documents.last {
                    self.lastFeed = lastDocument
                }
                let posts = documents.compactMap {
                    do {
                        return try $0.data(as: Post.self)
                    } catch {
                        return nil
                    }
                }
                single(.success(posts))
            }
            return Disposables.create()
        }
    }
}
