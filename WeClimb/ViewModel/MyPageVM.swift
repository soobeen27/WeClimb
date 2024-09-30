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
import FirebaseAuth

class MyPageVM {
    
    private let disposeBag = DisposeBag()
    
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
                    print("문서 ID: \(document.documentID)")
                    
                    if let post = try? document.data(as: Post.self) {
                        print("문서 데이터: \(post)")
                        
                        let mediaRefs = post.medias
                        let mediaDocuments = try await Firestore.firestore().getAllDocuments(from: mediaRefs)
                        
                        let allMedia = mediaDocuments.compactMap { try? $0.data(as: Media.self) }
                        
                        let thumbnailURL = post.thumbnail
                        
                        postsWithMedia.append((post: post, media: allMedia, thumbnailURL: thumbnailURL))
                    } else {
                        print("Post 데이터가 없거나 잘못된 형식입니다. Document ID: \(document.documentID)")
                        print("postsWithMedia: \(postsWithMedia)")
                    }
                }
                
                self.userMediaPosts.accept(postsWithMedia)
                
            } catch {
                print("미디어 포스트 가져오기 오류: \(error)")
            }
        }
    }
}
