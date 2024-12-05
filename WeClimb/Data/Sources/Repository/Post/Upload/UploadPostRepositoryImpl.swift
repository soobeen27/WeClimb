//
//  UploadPostRepositoryImpl.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import Foundation

import RxSwift

final class UploadPostRepositoryImpl: UploadPostRepository {
    private let uploadPostDataSource: UploadPostDataSource
    
    init(uploadPostDataSource: UploadPostDataSource) {
        self.uploadPostDataSource = uploadPostDataSource
    }
    
    func uploadPost(data: PostUploadData) -> Completable {
        return uploadPostDataSource.uploadPost(data: data)
    }
}
