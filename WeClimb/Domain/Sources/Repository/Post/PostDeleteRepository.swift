//
//  PostDeleteRepository.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/11/25.
//
import RxSwift

protocol PostDeleteRepository {
    func deletePost(uid: String) -> Single<Void>
}
