//
//  CommentRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

protocol CommentRepository {
    func AddCommnet(postUID: String, content: String) -> Single<Void>
    func FetchComments(postUID: String, postOwner: String) -> Single<[Comment]>
    func DeleteComments(postUID: String, commentUID: String) -> Single<Void>
}
