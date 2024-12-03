//
//  PostRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import Firebase
import RxSwift

protocol PostRepository {
    func posts(postRefs: [DocumentReference]) -> Observable<[Post]>
}
