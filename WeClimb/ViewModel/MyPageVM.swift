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
    let myPosts = BehaviorSubject<[Post]>(value: [])
    let thumbnailURLs = BehaviorSubject<[String]>(value: [])
    
    func loadUserThumbnailPosts() {
        FirebaseManager.shared.currentUserInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                guard let postRefs = user.posts else {
                    print("사용자의 포스트가 없습니다.")
                    return
                }
                
                self.fetchThumbnailURLs(from: postRefs)
            case .failure(let error):
                print("현재 유저 정보 가져오기 오류: \(error)")
            }
        }
    }
    
    // 포스트의 썸네일 URL만 가져오기
    private func fetchThumbnailURLs(from refs: [DocumentReference]) {
        Task {
            do {
                let documents = try await Firestore.firestore().getAllDocuments(from: refs) // Firestore에서 문서 가져오기
                
                var urls: [String] = []
                
                for document in documents {
                    // 문서 데이터 가져오기
                    guard let data = document.data(),
                          let mediaRefs = data["medias"] as? [DocumentReference] else {
                        print("문서 데이터가 없거나 잘못된 형식입니다.")
                        continue
                    }
                    
                    let mediaDocuments = try await Firestore.firestore().getAllDocuments(from: mediaRefs)
                    
                    // 첫 번째 미디어의 URL을 썸네일로 사용
                    if let mediaDocument = mediaDocuments.first,
                       let mediaData = mediaDocument.data(),
                       let thumbnailURL = mediaData["url"] as? String {
                        
                        urls.append(thumbnailURL)
                    }
                }
                
                self.thumbnailURLs.onNext(urls)
                
            } catch {
                print("썸네일 URL 가져오기 오류: \(error)")
            }
        }
    }
}
