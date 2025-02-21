//
//  PostFilterRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import Foundation

import Firebase
import RxSwift

final class PostFilterRepositoryImpl: PostFilterRepository {
    private let postFilterDataSource: PostFilterDataSource
    
    init(postFilterDataSource: PostFilterDataSource) {
        self.postFilterDataSource = postFilterDataSource
    }
    
    func getFilteredPost(lastSnapshot: QueryDocumentSnapshot?,
                         gymName: String,
                         grade: String?,
                         hold: String?,
                         height: [Int]?,
                         armReach: [Int]?,
                         completion: @escaping (QueryDocumentSnapshot?) -> Void) -> Single<[Post]> {
        return postFilterDataSource.getFilteredPost(lastSnapshot: lastSnapshot,
                                                    gymName: gymName,
                                                    grade: grade,
                                                    hold: hold,
                                                    height: height,
                                                    armReach: armReach) { snapshot in
            completion(snapshot)
        }
    }
}
