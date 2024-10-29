//
//  UserPageVM.swift
//  WeClimb
//
//  Created by 머성이 on 9/18/24.
//

import RxCocoa
import RxSwift
import FirebaseFirestore
import FirebaseStorage

class UserPageVM {
    
    private let userSubject = BehaviorSubject<User?>(value: nil)
//    let userMediaPosts = BehaviorRelay<[(post: Post, media: [Media], thumbnailURL: String?)]>(value: [])
    let posts = BehaviorRelay<[Post]>(value: [])
    
    // 유저 데이터를 관찰하는 Observable
    var userData: Observable<User?> {
        return userSubject.asObservable()
    }
    
    // 차단로직
    func blockUser(byUID uid: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.shared.addBlackList(blockedUser: uid) { success in
            if success {
                print("차단 성공")
                completion(true)
            } else {
                print("차단 실패")
                completion(false)
            }
        }
    }
    
    func fetchUserInfo(userName: String) {
        FirebaseManager.shared.getUserInfoFrom(name: userName) { [weak self] result in
            switch result {
            case .success(let user):
                self?.userSubject.onNext(user)
                guard let postRefs = user.posts else {
                    print("사용자의 포스트가 없음.")
                    return
                }
                self?.fetchUserPosts(from: postRefs)
            case .failure(let error):
                print("사용자 정보를 가져오는데 실패: \(error)")
                self?.userSubject.onError(error)
            }
        }
    }
    
    // 유저의 포스트를 가져오는 함수
//    private func fetchUserMediaPosts(from refs: [DocumentReference]) {
//        Task {
//            do {
//                let documents = try await Firestore.firestore().getAllDocuments(from: refs)
//                var postsWithMedia: [(post: Post, media: [Media], thumbnailURL: String?)] = []
//                
//                for document in documents {
//                    if let post = try? document.data(as: Post.self) {
//                        let mediaRefs = post.medias
//                        let mediaDocuments = try await Firestore.firestore().getAllDocuments(from: mediaRefs)
//                        
//                        let allMedia = mediaDocuments.compactMap { try? $0.data(as: Media.self) }
//                        
//                        let thumbnailURL = post.thumbnail ?? "no_Post"
//                        
////                        postsWithMedia.append((post: post, media: allMedia, thumbnailURL: thumbnailURL))
//                    } else {
//                        print("Post 데이터가 없거나 잘못된 형식입니다. Document ID: \(document.documentID)")
//                    }
//                }
//                
//                let sortedPosts = postsWithMedia.sorted { $0.post.creationDate > $1.post.creationDate }
////                self.userMediaPosts.accept(sortedPosts)
//                
//            } catch {
//                print("미디어 포스트 가져오기 오류: \(error)")
//            }
//        }
//    }
    private func fetchUserPosts(from refs: [DocumentReference]) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let documents = try await Firestore.firestore().getAllDocuments(from: refs)
                var posts: [Post] = []
                for document in documents {
                    if let post = try? document.data(as: Post.self) {
                        posts.append(post)
                    } else {
                        print("Post 데이터가 없거나 잘못된 형식입니다. Document ID: \(document.documentID)")
                    }
                }
                
                let sortedPosts = posts.sorted { $0.creationDate > $1.creationDate }
                self.posts.accept(sortedPosts)
                
            } catch {
                print("미디어 포스트 가져오기 오류: \(error)")
            }
        }
    }
}
