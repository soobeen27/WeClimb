//
//  ImageDataRepository.swift
//  WeClimb
//
//  Created by 머성이 on 12/2/24.
//

import Foundation

import RxSwift

protocol FirebaseImageRepository {
    func fetchImageURL(from gsURL: String) -> Single<String?>
}
