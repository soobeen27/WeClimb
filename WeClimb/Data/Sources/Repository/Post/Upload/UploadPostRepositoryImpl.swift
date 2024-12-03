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
    
    func uploadPost(user: User, gym: String?, caption: String?, datas: [(url: URL, hold: String?, grade: String?, thumbnailURL: URL?)]) -> Completable {
        return uploadPostDataSource.uploadPost(user: user, gym: gym, caption: caption, datas: datas)
    }
}
