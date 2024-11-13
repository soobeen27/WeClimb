//
//  MainFeedVM.swift
//  WeClimb
//
//  Created by 김솔비 on 8/29/24.
//

import Foundation

import RxCocoa
import RxSwift
import Firebase


class MainFeedVM {
    struct Input {
        let reportDeleteButtonTap: Driver<Post?>
        let commentButtonTap: Driver<Post?>
        let profileTap: Driver<String?>
//        let likeButtonTap: Driver<Post?>
    }
    
    struct Output {
        let presentReport: Driver<Post?>
        let presentComment: Driver<Post?>
        let pushProfile: Driver<String?>
//        let like: Driver<Post?>
    }
    
    private let disposeBag = DisposeBag()
    var posts = BehaviorRelay<[Post]>(value: [])
    var isLastCell = BehaviorRelay<Bool>(value: false)
    
    let db = Firestore.firestore()
    
    func transform(input: Input) -> Output {
        return Output(presentReport: input.reportDeleteButtonTap, 
                      presentComment: input.commentButtonTap,
                      pushProfile: input.profileTap  )
//                      like: input.likeButtonTap )
    }
    
    func mainFeed() {
        fetchInitialFeed()
        isLastCell
            .subscribe(onNext: { [weak self] shouldLoad in
                guard let self else { return }
                if shouldLoad {
                    self.fetchMoreFeed()
                }
        })
        .disposed(by: disposeBag)
        
    }
    
    // 피드 데이터 초기 로드
    func fetchInitialFeed() {
        FirebaseManager.shared.feedFirst { [weak self] fetchedPosts in
            guard let self, let fetchedPosts = fetchedPosts else { return }
            self.posts.accept(fetchedPosts)
        }
    }
    
    // 추가 데이터 로드
    private func fetchMoreFeed() {
        FirebaseManager.shared.feedLoading { [weak self] fetchedPosts in
            guard let self, let fetchedPosts = fetchedPosts else { return }
            var loadedPosts = self.posts.value
            fetchedPosts.forEach {
                loadedPosts.append($0)
            }
            
            self.posts.accept(loadedPosts)
        }
    }
    
    func fetchMyPosts() {
        FirebaseManager.shared.currentUserInfo { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                guard let posts = user.posts else { return }
                FirebaseManager.shared.postsFrom(postRefs: posts)
                    .subscribe(onNext: { data in
                        self.posts.accept(data)
                    }, onError: { error in
                        print("Error - while getting posts: \(error)")
                    })
                    .disposed(by: disposeBag)
            case .failure(let error):
                print("Error - while getting User Info: \(error)")
            }
        }
    }
    
    func deletePost(uid: String) -> Single<Void> {
        return FirebaseManager.shared.deletePost(uid: uid)
    }
//    
//    func likePost(myUID: String, postUID: String)  {
//            let postRef = db.collection("posts").document(postUID)
//            self.db.runTransaction { transaction, errorPointer in
//                let postSnapshot: DocumentSnapshot
//                do {
//                    postSnapshot = try transaction.getDocument(postRef)
//                } catch let fetchError as NSError {
//                    errorPointer?.pointee = fetchError
//                    return nil
//                }
//                var currentLikeList = postSnapshot.data()?["like"] as? [String] ?? []
//                
//                if currentLikeList.contains([myUID]) {
//                    transaction.updateData(["like" : FieldValue.arrayRemove([myUID])], forDocument: postRef)
//                    currentLikeList.removeAll { $0 == myUID }
//                } else {
//                    transaction.updateData(["like" : FieldValue.arrayUnion([myUID])], forDocument: postRef)
//                    currentLikeList.append(myUID)
//                }
//                return currentLikeList
//            } completion: { object, error in
//                if let error = error {
//                    print("Error : \(error) ", #file, #function, #line)
//                    return
//                } else if let likeList = object as? [String] {
//                    self.postLikeList.accept(likeList)
//                }
//            }
//    }
}
