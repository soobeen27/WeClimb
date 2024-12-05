//
//  UploadPostRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import Foundation

import RxSwift

protocol UploadPostRepository {
    func uploadPost(data: PostUploadData) -> Completable
}
