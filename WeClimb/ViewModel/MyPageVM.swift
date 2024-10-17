//
//  MyPageVM.swift
//  WeClimb
//
//  Created by 강유정 on 8/27/24.
//

import UIKit

import RxSwift
import RxCocoa
import FirebaseFirestore

class MyPageVM {
    
    let userMediaPosts = BehaviorRelay<[(post: Post, media: [Media], thumbnailURL: String?)]>(value: [])
    
    func loadUserMediaPosts() {
        FirebaseManager.shared.currentUserInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                guard let postRefs = user.posts else {
                    print("사용자의 포스트가 없습니다.")
                    return
                }
                self.fetchUserMediaPosts(from: postRefs)
            case .failure(let error):
                print("현재 유저 정보 가져오기 오류: \(error)")
            }
        }
    }
    
    private func fetchUserMediaPosts(from refs: [DocumentReference]) {
        Task {
            do {
                let documents = try await Firestore.firestore().getAllDocuments(from: refs)
                var postsWithMedia: [(post: Post, media: [Media], thumbnailURL: String?)] = []
                
                for document in documents {
                    if let post = try? document.data(as: Post.self) {
                        let mediaRefs = post.medias
                        let mediaDocuments = try await Firestore.firestore().getAllDocuments(from: mediaRefs)
                        
                        let allMedia = mediaDocuments.compactMap { try? $0.data(as: Media.self) }
                        
                        let thumbnailURL = post.thumbnail ?? "no_Post"
                        
                        postsWithMedia.append((post: post, media: allMedia, thumbnailURL: thumbnailURL))
                    } else {
                        print("Post 데이터가 없거나 잘못된 형식입니다. Document ID: \(document.documentID)")
                    }
                }
                
                let sortedPosts = postsWithMedia.sorted { $0.post.creationDate > $1.post.creationDate }
                self.userMediaPosts.accept(sortedPosts)
                
            } catch {
                print("미디어 포스트 가져오기 오류: \(error)")
            }
        }
    }
}
