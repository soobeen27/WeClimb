//
//  CommentRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

protocol CommentRepository {
    func addCommnet(postUID: String, content: String) -> Single<Void>
    func fetchComments(postUID: String, postOwner: String) -> Single<[Comment]>
    func deleteComments(postUID: String, commentUID: String) -> Single<Void>
}
