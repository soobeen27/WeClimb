//
//  PostFilterRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import Foundation

import Firebase
import RxSwift

protocol PostFilterRepository {
    func getFilteredPost(lastSnapshot: QueryDocumentSnapshot?,
                         gymName: String,
                         grade: String,
                         hold: String?,
                         height: [Int]?,
                         armReach: [Int]?,
                         completion: @escaping (QueryDocumentSnapshot?) -> Void) -> Single<[Post]>
}
