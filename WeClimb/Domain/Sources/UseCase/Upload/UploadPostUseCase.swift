//
//  UploadPostUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 2/11/25.
//

import Foundation

import RxSwift

protocol UploadPostUseCase {
    func execute(data: PostUploadData) -> Completable
}

class UploadPostUseCaseImpl: UploadPostUseCase {
    private let uploadPostRepository: UploadPostRepository
    
    init(uploadPostRepository: UploadPostRepository) {
        self.uploadPostRepository = uploadPostRepository
    }
    
    func execute(data: PostUploadData) -> Completable {
        return uploadPostRepository.uploadPost(data: data)
    }
}
