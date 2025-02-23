//
//  PostRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import Firebase
import RxSwift

final class PostRepositoryImpl: PostRepository {
    private let postDataSource: PostDataSource
    
    init(postDataSource: PostDataSource) {
        self.postDataSource = postDataSource
    }
    
    func posts(postRefs: [DocumentReference]) -> Observable<[Post]> {
        return postDataSource.posts(postRefs: postRefs)
    }
}
