//
//  PostFilterDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/2/24.
//

import Foundation
import RxSwift
import Firebase

protocol PostFilterDataSource {
    func getFilteredPost(lastSnapshot: QueryDocumentSnapshot?, gymName: String, grade: String,
                          hold: String?, height: [Int]?,
                         armReach: [Int]?,
                         completion: @escaping (QueryDocumentSnapshot?) -> Void) -> Single<[Post]>
}

class PostFilterDataSourceImpl: PostFilterDataSource {
    private let db = Firestore.firestore()
    
    /// 필터가 적용된 포스트를 반환하는 메소드
    /// - Parameters:
    ///   - lastSnapshot: 무한 스크롤을 위한 마지막 스냅샷
    ///   - gymName: 암장이름
    ///   - grade: 난이도
    ///   - hold: 홀드색
    ///   - height: 키 범위 [작은수, 큰수]
    ///   - armReach: 암리치 범위 [작은수, 큰수]
    ///   - completion: 무한스크롤을 위한 마지막 스냅샷을 넘김. 이걸 따로 저장해뒀다가 더 로딩해야할때 lastSnapshot에 넣으면됨
    /// - Returns: 필터가 적용된 하나의 미디어만 가진 포스트
    func getFilteredPost(lastSnapshot: QueryDocumentSnapshot? = nil, gymName: String, grade: String,
                          hold: String? = nil, height: [Int]? = nil,
                         armReach: [Int]? = nil,
                         completion: @escaping (QueryDocumentSnapshot?) -> Void) -> Single<[Post]> {
        let answerQuery = filteredPostQuery(gymName: gymName, grade: grade,
                                            hold: hold, height: height,
                                            armReach: armReach, lastSnapshot: lastSnapshot)
        
        return getFilteredMedia(query: answerQuery, completionHandler: { snapshot in
            completion(snapshot)
        })
            .flatMap { [weak self] medias in
                guard let self = self else { return .just([]) }
                return self.getSingleMediaPosts(medias: medias)
            }
    }
    
    private func filteredPostQuery(gymName: String,
                                   grade: String,
                                   hold: String? = nil,
                                   height: [Int]? = nil,
                                   armReach: [Int]? = nil,
                                   lastSnapshot: QueryDocumentSnapshot? = nil
    ) -> Query {
        var answerQuery = self.db.collection("media")
            .whereField("gym", isEqualTo: gymName)
            .whereField("grade", isEqualTo: grade)
            .order(by: "creationDate", descending: true)
        
        if let hold {
            answerQuery = answerQuery.whereField("hold", isEqualTo: hold)
        }
        if let height {
            answerQuery = answerQuery.whereField("height", isGreaterThanOrEqualTo: height[0])
                .whereField("height", isLessThanOrEqualTo: height[1])
        }
        if let armReach {
            answerQuery = answerQuery.whereField("armReach", isGreaterThanOrEqualTo: armReach[0])
                .whereField("armReach", isLessThanOrEqualTo: armReach[1])
        }
        if let lastPost = lastSnapshot {
            answerQuery = answerQuery.start(afterDocument: lastPost)
        }
        return answerQuery
    }
    
    private func getFilteredMedia(query: Query,
                                  completionHandler: @escaping (QueryDocumentSnapshot?) -> Void) -> Single<[Media]> {
        return Single.create { single in
            query.getDocuments { snapshot, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let snapshot else {
                    single(.success([]))
                    return
                }
                var medias: [Media] = []
                completionHandler(snapshot.documents.last)
                for document in snapshot.documents {
                    do {
                        let media = try document.data(as: Media.self)
                        medias.append(media)
                    } catch {
                        print(error)
                    }
                }
                single(.success(medias))
            }
            return Disposables.create()
        }
    }

    private func getSingleMediaPosts(medias: [Media]) -> Single<[Post]> {
        let postObservables = medias.map { [weak self] media -> Single<Post?> in
            guard let self = self else { return .just(nil) }
            return Single<Post?>.create { single in
                guard let postRef = media.postRef else {
                    return Disposables.create()
                }
                postRef.getDocument { snapshot, error in
                    if let error = error {
                        print("Error - get post \(error)")
                        single(.success(nil))
                        return
                    }
                    
                    guard let data = snapshot?.data(),
                          let postUID = data["postUID"] as? String,
                          let authorUID = data["authorUID"] as? String,
                          let creationDate = data["creationDate"] as? Timestamp,
                          let thumbnail = media.thumbnailURL else {
                              single(.success(nil))
                              return
                    }

                    let filteredPostMediaRef = self.db.collection("media").document(media.mediaUID)
                    
                    let post = Post(postUID: postUID,
                                    authorUID: authorUID,
                                    creationDate: creationDate.dateValue(),
                                    caption: data["caption"] as? String,
                                    like: data["like"] as? [String],
                                    gym: data["gym"] as? String,
                                    medias: [filteredPostMediaRef],
                                    thumbnail: thumbnail,
                                    commentCount: data["commentCount"] as? Int)
                    
                    single(.success(post))
                }
                return Disposables.create()
            }
            .catchAndReturn(nil)
        }
        return Single.zip(postObservables)
            .map { $0.compactMap { $0 } }
    }

}
