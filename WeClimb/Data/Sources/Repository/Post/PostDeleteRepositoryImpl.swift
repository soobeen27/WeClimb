//
//  PostDeleteRepositoryImpl.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/11/25.
//
import RxSwift

class PostDeleteRepositoryImpl: PostDeleteRepository {
    let postDeleteDataSource: PostDeleteDataSource
    
    init(postDeleteDataSource: PostDeleteDataSource) {
        self.postDeleteDataSource = postDeleteDataSource
    }
    
    func deletePost(uid: String) -> Single<Void> {
        postDeleteDataSource.deletePost(uid: uid)
    }
}
