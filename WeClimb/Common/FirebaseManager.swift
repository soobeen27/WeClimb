//
//  FirebaseManager.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/5/24.
//
import UIKit

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFunctions
import FirebaseStorage
import GoogleSignIn
import RxSwift
import Kingfisher
import AVFoundation


final class FirebaseManager {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let disposeBag = DisposeBag()
    private var lastFeed: QueryDocumentSnapshot?
    // 중복 요청 방지 및 캐싱 관리
    private var ongoingRequests = [String: Bool]()
    private var urlCache = NSCache<NSString, NSURL>()
    private var imageCache = NSCache<NSString, UIImage>()
    
    static let shared = FirebaseManager()
    private init() {}
    
    //MARK: 현재 유저 uid
    func currentUserUID() -> String {
        guard let user = Auth.auth().currentUser else {
            return ""
        }
        return user.uid
    }
    // MARK: 유저 정보 업데이트
    func updateAccount(with data: String, for field: UserUpdate, completion: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let userRef = db.collection("users").document(user.uid)
        userRef.updateData([field.key : data]) { error in
            if let error = error {
                print("업데이트 에러!: \(error.localizedDescription)")
                return
            }
            completion()
        }
    }
    
    // MARK: 차단 관련
    func addBlackList(blockedUser uid: String, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        let userRef = db.collection("users").document(user.uid)
        
        userRef.updateData(["blackList" : FieldValue.arrayUnion([uid])]) { error in
            if let error = error {
                print("차단하는 과정중 에러: \(error)")
                completion(false)
            }
            print("차단 성공")
            completion(true)
        }
    }
    
    func removeBlackList(blockedUser uid: String, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        let userRef = db.collection("users").document(user.uid)
        
        userRef.updateData(["blackList" : FieldValue.arrayRemove([uid])]) { error in
            if let error = error {
                print("차단 해제중 오류: \(error)")
                completion(false)
            }
            print("차단 해제 성공")
            completion(true)
        }
    }
    
    // MARK: 프로필이미지 업로드
    func uploadProfileImage(image: URL) -> Observable<URL> {
        guard let user = Auth.auth().currentUser else { return Observable.error(UserError.none) }
        let storageRef = self.storage.reference()
        let profileImageRef = storageRef.child("users/\(user.uid)/profileImage.jpg")
        
        return Observable<URL>.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            profileImageRef.putFile(from: image, metadata: nil) { metaData, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                profileImageRef.downloadURL { url, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    guard let url else {
                        print("url 없음")
                        return
                    }
                    
                    self.updateAccount(with: url.absoluteString, for: .profileImage) {
                        observer.onNext(url)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    //  MARK: 닉네임 중복 체크, 중복일 시 true 리턴 중복값 아니면 false 리턴
    func duplicationCheck(with name: String, completion: @escaping (Bool) -> Void) {
        let ref = db.collection("users").whereField("userName", isEqualTo: name)
        
        ref.getDocuments() { snapshot, error in
            if let error = error {
                print("중복체크에러: \(error)")
                completion(false)
            }
            if let documents = snapshot?.documents, !documents.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // MARK: 현재 유저 정보 가져오기
    func currentUserInfo(completion: @escaping (Result<User, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { 
            completion(.failure(UserError.logout))
            return
        }
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                print("현재 유저 가져오기 에러: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: 내 포스트 가져오기 최신순
    func postsFrom(postRefs: [DocumentReference]) -> Observable<[Post]> {
        let posts = postRefs.map { ref in
            return Observable<Post>.create { observer in
                ref.getDocument { document, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    guard let document, document.exists else { return }
                    do {
                        let post = try document.data(as: Post.self)
                        observer.onNext(post)
                    } catch {
                        observer.onError(error)
                    }
                }
                return Disposables.create()
            }
        }
        return Observable.zip(posts).map {
            $0.sorted {
                $0.creationDate > $1.creationDate
            }
        }
    }
    
    
    //MARK: 사용자 검색 함수 (User 모델에 맞게 업데이트)
    func searchUsers(with searchText: String, completion: @escaping ([User], [String], Error?) -> Void) {
        db.collection("users")
            .whereField("userName", isGreaterThanOrEqualTo: searchText)
            .whereField("userName", isLessThanOrEqualTo: searchText + "\u{f8ff}")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion([], [], error)
                } else if let querySnapshot = querySnapshot {
                    var users: [User] = []
                    var uids: [String] = []  // UID를 저장하는 별도 배열
                    for document in querySnapshot.documents {
                        do {
                            let user = try document.data(as: User.self)
                            users.append(user)
                            uids.append(document.documentID)  // UID를 별도의 배열에 저장
                        } catch {
                            print("Error decoding user: \(error)")
                        }
                    }
                    completion(users, uids, nil)
                } else {
                    // 에러도 없고, querySnapshot도 없는 경우
                    completion([], [], nil)
                }
            }
    }
    
    // MARK: 다른 유저 정보 가져오기
    func getUserInfoFrom(name: String, completion: @escaping (Result<User, Error>) -> Void) {
        let userRef = db.collection("users").whereField("userName", isEqualTo: name)
        
        userRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let snapshot else { return }
            snapshot.documents.forEach { document in
                if let user = try? document.data(as: User.self) {
                    completion(.success(user))
                } else {
                    completion(.failure(UserError.none))
                }
            }
        }
    }
    
    func getUserInfoFrom(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let snapshot, snapshot.exists else {
                completion(.failure(UserError.none))
                return }
            do {
                try completion(.success(snapshot.data(as: User.self)))
            } catch {
                completion(.failure(UserError.none))
            }
            //            snapshot.documents.forEach { document in
            //                if let user = try? document.data(as: User.self) {
            //                    completion(.success(user))
            //                } else {
            //                    completion(.failure(UserError.none))
            //                }
            //            }
        }
    }
    
    // MARK: 모든 암장이름 가져오기 (검색용)
    func allGymName(completion: @escaping ([String]) -> Void) {
        db.collection("climbingGyms").getDocuments { snapshot, error in
            if let error = error {
                print("모든 클라이밍장 이름 가져오기 에러: \(error)")
                completion([])
                return
            }
            guard let documents = snapshot?.documents else {
                print("아무런 문서가 없음")
                completion([])
                return
            }
            let documentNames = documents.map {
                $0.documentID
            }
            completion(documentNames)
        }
    }
    
    // MARK: 특정 암장정보 from 이름
    func gymInfo(from name: String, completion: @escaping (Gym?) -> Void) {
        db.collection("climbingGyms")
            .document(name)
            .getDocument { document, error in
                if let error = error {
                    print("암장 정보 가져오기 에러: \(error)")
                    completion(nil)
                    return
                }
                guard let document = document, document.exists,
                      let data = document.data()
                else {
                    print("정보없음")
                    completion(nil)
                    return
                }
                guard let address = data["address"] as? String,
                      let grade = data["grade"] as? String,
                      let gymName = data["gymName"] as? String,
                      let sector = data["sector"] as? String,
                      let profileImage = data["profileImage"] as? String
                else {
                    print("필수 정보 없음")
                    completion(nil)
                    return
                }
                var additionalInfo = data
                additionalInfo.removeValue(forKey: "address")
                additionalInfo.removeValue(forKey: "grade")
                additionalInfo.removeValue(forKey: "gymName")
                additionalInfo.removeValue(forKey: "sector")
                additionalInfo.removeValue(forKey: "profileImage")
                
                completion(Gym(address: address, grade: grade,
                               gymName: gymName, sector: sector,
                               profileImage: profileImage, additionalInfo: additionalInfo))
            }
    }
    // MARK: 포스트 업로드
    func uploadPost(myUID: String, media: [(url: URL, hold: String?, grade: String?, thumbnailURL: String?)], caption: String?, gym: String?, thumbnail: String) async {
        
        let storageRef = storage.reference()
        let db = Firestore.firestore()
        let postUID = UUID().uuidString
        let postRef = db.collection("posts").document(postUID)
        let creationDate = Date()
        var user: User?
        getUserInfoFrom(uid: myUID) { result in
            switch result {
            case .success(let userdata):
                user = userdata
            case .failure(let error):
                print("Error - while getUserInfoFrom \(error)")
            }
        }
        do {
            let batch = db.batch()
            
            var mediaReferences: [DocumentReference] = []
            var thumbnails: [String] = []
            
            for media in media.enumerated() {
                let fileName = media.element.url.lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? media.element.url.lastPathComponent
                let mediaRef = storageRef.child("users/\(myUID)/\(fileName)")
                let mediaURL = try await uploadMedia(mediaRef: mediaRef, mediaURL: media.element.url)
                
                let thumbnailURL = media.element.thumbnailURL ?? ""
                thumbnails.append(thumbnailURL)
                
                let mediaUID = UUID().uuidString
                let mediaDocRef = db.collection("media").document(mediaUID)
                
                let mediaData = Media(
                    mediaUID: mediaUID,
                    url: mediaURL.absoluteString,
                    hold: media.element.hold,
                    grade: media.element.grade,
                    gym: gym,
                    creationDate: creationDate,
                    postRef: postRef,
                    thumbnailURL: thumbnailURL,
                    height: user?.height,
                    armReach: user?.armReach
                )
                
                batch.setData(try Firestore.Encoder().encode(mediaData), forDocument: mediaDocRef)
                
                mediaReferences.append(mediaDocRef)
            }
            let post = Post(postUID: postUID,
                            authorUID: myUID,
                            creationDate: creationDate,
                            caption: caption,
                            like: nil,
                            gym: gym,
                            medias: mediaReferences,
                            thumbnail: thumbnails.first ?? "",
                            commentCount: nil
            )
            
            let userRef = db.collection("users").document(myUID)
            batch.setData(try Firestore.Encoder().encode(post), forDocument: postRef)
            batch.updateData(["posts": FieldValue.arrayUnion([postRef])], forDocument: userRef)
            
            try await batch.commit()
            print("포스트 업로드 및 미디어 저장 완료")
            
        } catch {
            print("업로드 중 오류 발생: \(error)")
        }
    }
    
    func uploadMedia(mediaRef: StorageReference, mediaURL: URL) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            mediaRef.putFile(from: mediaURL, metadata: nil) { metaData, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                mediaRef.downloadURL { url, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let url = url {
                        continuation.resume(returning: url)
                    }
                }
            }
        }
    }

    // MARK: 댓글달기
    func addComment(fromPostUid postUid: String, content: String) {
        guard let user = Auth.auth().currentUser else {
            print("로그인이 되지않음")
            return
        }
        let commentUID = UUID().uuidString
        let postRef = db.collection("posts").document(postUid)
        let userRef = self.db.collection("users").document(user.uid)
        let commentRef = db.collection("posts").document(postUid).collection("comments").document(commentUID)
        let comment = Comment(commentUID: commentUID, authorUID: user.uid, content: content, creationDate: Date(), like: nil, postRef: postRef)
        do {
            try commentRef.setData(from: comment) { error in
                if let error = error {
                    print("댓글 다는중 오류\(error)")
                    return
                }
                userRef.updateData(["comments" : FieldValue.arrayUnion([commentRef])])
            }
        } catch {
            print("댓글 작성중 에러")
        }
    }
    
    // MARK: 특정 포스트의 댓글 가져오기
    func comments(postUID: String, postOwner: String, completion: @escaping ([Comment]?) -> Void) {
        let postRef = db.collection("users").document(postOwner).collection("posts").document(postUID).collection("comments")
        
        postRef.getDocuments { snapshot, error in
            if let error = error {
                print("댓글 가져오기 오류: \(error)")
                completion(nil)
                return
            }
            guard let documents = snapshot?.documents else {
                completion(nil)
                return
            }
            let comments: [Comment] = documents.compactMap { document in
                do {
                    return try document.data(as: Comment.self)
                } catch {
                    return nil
                }
            }
            let sortedComments = comments.sorted { $0.creationDate > $1.creationDate }
            
            completion(sortedComments)
        }
    }
    
    //MARK: 좋아요
    /// 좋아요
    /// - Parameters:
    ///   - myUID: 로그인된 계정 uid
    ///   - targetUID: 좋아요 누를 포스트 or 댓글 uid
    ///   - type: 포스트 or 댓글
    /// - Returns: 좋아요 누른 uid array
    func like(myUID: String, targetUID: String, type: Like) -> Single<[String]> {
        return Single.create(subscribe: { [weak self] single in
            guard let self else {
                single(.failure(CommonError.noSelf))
                return Disposables.create()
            }
            let targetRef = self.db.collection("posts").document(targetUID)
            self.db.runTransaction { transaction, errorPointer in
                let postSnapshot: DocumentSnapshot
                do {
                    postSnapshot = try transaction.getDocument(targetRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    single(.failure(fetchError as Error))
                    return nil
                }
                var currentLikeList = postSnapshot.data()?["like"] as? [String] ?? []
                
                if currentLikeList.contains([myUID]) {
                    transaction.updateData(["like" : FieldValue.arrayRemove([myUID])], forDocument: targetRef)
                    currentLikeList.removeAll { $0 == myUID }
                } else {
                    transaction.updateData(["like" : FieldValue.arrayUnion([myUID])], forDocument: targetRef)
                    currentLikeList.append(myUID)
                }
                return currentLikeList
            } completion: { object, error in
                if let error = error {
                    print("Error : \(error) ", #file, #function, #line)
                    single(.failure(error))
                    return
                } else if let likeList = object as? [String] {
                    single(.success(likeList))
                }
            }
            return Disposables.create()
        })
    }
    
    func fetchLike(from uid: String, type: Like) -> Observable<[String]> {
        return Observable<[String]>.create { [weak self] observer in
            guard let self else {
                observer.onError(CommonError.noSelf)
                return Disposables.create()
            }
            let contentRef = self.db.collection(type.string).document(uid)
            contentRef.getDocument { document, error in
                if let error = error {
                    print("좋아요 목록 가져오는 중 에러: \(error)")
                    observer.onError(error)
                    return
                }
                guard let document, document.exists else {
                    observer.onError(UserError.none)
                    return
                }
                guard let likeList = document.get("like") as? [String] else {
                    print("라이크 없음")
                    return
                }
                observer.onNext(likeList)
            }
            return Disposables.create()
        }
    }
    
    
    // MARK: 피드가져오기 (처음 실행되어야할 메소드)
    func feedFirst(completion: @escaping ([Post]?) -> Void) {
        var postRef = db.collection("posts")
            .order(by: "creationDate", descending: true)
            .limit(to: 5)
        
        currentUserInfo { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                if let blackList = user.blackList, !blackList.isEmpty {
                    postRef = postRef
                        .whereField("authorUID", notIn: blackList)
                    }
                
                self.getPost(postRef: postRef) { post in
                    completion(post)
                }
            case .failure(let error):
                print("유저 정보 가져오는 중 에러: \(error)")
                self.getPost(postRef: postRef) { post in
                    completion(post)
                }
            }
        }
    }
    
    func feedLoading(completion: @escaping ([Post]?) -> Void) {
        guard let lastFeed else { return }
        var postRef = db.collection("posts")
            .order(by: "creationDate", descending: true)
            .limit(to: 5)
            .start(afterDocument: lastFeed)
        
        currentUserInfo { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                if let blackList = user.blackList, !blackList.isEmpty {
                    postRef = postRef
                        .whereField("authorUID", notIn: blackList)
                }
                self.getPost(postRef: postRef) { post in
                    completion(post)
                }
            case .failure(let error):
                print("유저 정보 가져오는 중 에러: \(error)")
                self.getPost(postRef: postRef) { post in
                    completion(post)
                }
            }
        }
    }
    
    private func getPost(postRef: Query, completion: @escaping ([Post]?) -> Void ) {
        postRef.getDocuments { [weak self] snapshot, error in
            guard let self else { return }
            if let error = error {
                print("피드 가져오는중 에러: \(error)")
                completion(nil)
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("현재 피드가 없음")
                completion(nil)
                return
            }
            
            if let lastDocument = documents.last {
                self.lastFeed = lastDocument
            }
            
            let posts = documents.compactMap {
                do {
                    return try $0.data(as: Post.self)
                } catch {
                    return nil
                }
            }
            print(posts)
            completion(posts)
        }
    }

    func fetchMedias(for post: Post) -> Single<[Media]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            Task { [weak self] in
                guard let self else { return }
                do {
                    let mediaRefs: [DocumentReference] = post.medias
                    var medias: [Media] = []
                    
                    guard !mediaRefs.isEmpty else {
                        single(.success(medias))
                        return
                    }
                    
                    let batchQuery = try await self.db.getAllDocuments(from: mediaRefs)
                    
                    let mediaDict: [String: Media] = batchQuery.compactMap { document in
                        if let media = try? document.data(as: Media.self) {
                            return (document.documentID, media)
                        } else {
                            return nil
                        }
                    }.reduce(into: [:]) { dict, item in
                        dict[item.0] = item.1
                    }
                    
                    medias = mediaRefs.compactMap { ref in
                        mediaDict[ref.documentID]
                    }
                    
                    single(.success(medias))
                } catch {
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }


    
    //MARK: 팔로우, 언팔
    /// 팔로우, 언팔로우
    /// - Parameters:
    ///   - myUID: 로그인되어있는 계정 uid
    ///   - targetUID: 팔로우, 언팔할 계정 uid
    /// - Returns: 팔로우, 언팔 후 로그인된 계정이 팔로우하고 있는 배열
    func follow(myUID: String, targetUID: String) -> Single<[String]>{
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CommonError.noSelf))
                return Disposables.create()
            }
            
            let myRef = self.db.collection("users").document(myUID)
            let targetRef = self.db.collection("users").document(targetUID)
            
            self.db.runTransaction { (transaction, errorPointer) -> [String]? in
                let userSnapshot: DocumentSnapshot
                do {
                    userSnapshot = try transaction.getDocument(myRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    single(.failure(fetchError as Error))
                    return nil
                }
                var currentFollowList = userSnapshot.data()?["following"] as? [String] ?? []
                
                if currentFollowList.contains([targetUID]) {
                    transaction.updateData(["following": FieldValue.arrayRemove([targetUID])], forDocument: myRef)
                    transaction.updateData(["followers" : FieldValue.arrayRemove([myUID])], forDocument: targetRef)
                    currentFollowList.removeAll { $0 == targetUID }
                } else {
                    transaction.updateData(["following": FieldValue.arrayUnion([targetUID])], forDocument: myRef)
                    transaction.updateData(["followers" : FieldValue.arrayUnion([myUID])], forDocument: targetRef)
                    currentFollowList.append(targetUID)
                }
                return currentFollowList
            } completion: { (object, error) in
                if let error = error {
                    print("Error : \(error) ", #file, #function, #line)
                    single(.failure(error))
                    return
                } else if let followList = object as? [String] {
                    single(.success(followList))
                }
            }
            return Disposables.create()
        }
    }
    
    
    
    
    // MARK: - DS 작업 (유저 신고, HTTP 변환)
    // sns 수신동의 관련
    func updateSNSConsent(for userUID: String, consent: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(userUID)
        
        userRef.updateData(["snsConsent": consent]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // 유저 신고내역
    func userReport(content: String, userName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userReport: [String: Any] = [
            "content": content,
            "userName": userName,
            "time": Timestamp()
        ]
        
        db.collection("report").addDocument(data: userReport) { error in
            if let error = error {
                print("Firestore 오류 발생: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Firestore에 데이터가 성공적으로 추가되었습니다.")
                completion(.success(())) // Void 반환
            }
        }
    }
    
    // gs:// URL을 HTTP/HTTPS로 변환하는 함수
    func fetchImageURL(from gsURL: String, completion: @escaping (URL?) -> Void) {
        // 이미 캐싱된 URL이 있는지 확인
        if let cachedURL = urlCache.object(forKey: gsURL as NSString) {
            completion(cachedURL as URL)
            return
        }
        
        // 이미 요청 중인지 확인
        guard ongoingRequests[gsURL] == nil else {
            print("Request for \(gsURL) is already in progress.")
            completion(nil)
            return
        }
        
        // 요청 중 상태로 설정
        ongoingRequests[gsURL] = true
        
        let storageReference = storage.reference(forURL: gsURL)
        
        storageReference.downloadURL { [weak self] url, error in
            guard let self = self else { return }
            
            // 요청이 완료되었으므로 상태 제거
            self.ongoingRequests[gsURL] = nil
            
            if let error = error {
                print("Error converting gsURL to httpsURL: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let url = url {
                // 변환된 URL 캐싱
                self.urlCache.setObject(url as NSURL, forKey: gsURL as NSString)
            }
            
            // 완료된 URL 반환
            completion(url)
        }
    }
    
    // Kingfisher를 사용하여 이미지 로드하는 함수 (gs:// 및 http/https URL 모두 처리)
    func loadImage(from imageUrl: String?, into imageView: UIImageView) {
        guard let imageUrl = imageUrl else {
            imageView.image = UIImage(named: "defaultImage")
            return
        }
        
        // 이미 캐싱된 이미지 확인
        if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
            imageView.image = cachedImage
            return
        }
        
        if imageUrl.hasPrefix("gs://") {
            // gs:// URL을 HTTPS로 변환 후 이미지 로드
            fetchImageURL(from: imageUrl) { [weak self] httpsURL in
                guard let self = self, let httpsURL = httpsURL else {
                    imageView.image = UIImage(named: "defaultImage")
                    return
                }
                self.setImage(with: httpsURL, into: imageView, cacheKey: imageUrl)
            }
        } else {
            // HTTP/HTTPS URL 처리
            guard let url = URL(string: imageUrl) else {
                imageView.image = UIImage(named: "defaultImage")
                return
            }
            setImage(with: url, into: imageView, cacheKey: imageUrl)
        }
    }
    
    // Kingfisher로 이미지를 설정하는 함수
    private func setImage(with url: URL?, into imageView: UIImageView, cacheKey: String) {
        let options: KingfisherOptionsInfo = [
            .transition(.fade(0.2)), // 부드러운 페이드 애니메이션
            .cacheOriginalImage // 원본 이미지를 캐시
        ]
        
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"), options: options) { [weak self] result in
            switch result {
            case .success(let value):
                // 성공적으로 로드된 이미지를 캐시에 저장
                self?.imageCache.setObject(value.image, forKey: cacheKey as NSString)
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
    
    // 인자로 받아라
    func updateUserDetails(data: [String: Any], completion: @escaping (Bool) -> Void) {
        let uid = currentUserUID()
        guard !uid.isEmpty else {
            print("UID를 가져오지 못했습니다.")
            completion(false)
            return
        }
        
        let userRef = db.collection("users").document(uid)
        userRef.updateData(data) { error in
            if let error = error {
                print("업데이트 에러 발생: \(error.localizedDescription)")
                completion(false)
            } else {
                print("데이터 업데이트 성공!")
                completion(true)
            }
        }
    }
    
    // MARK: 로그인된 계정 삭제
    func userDelete(completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete() { [weak self] error in
            guard let self else { return }
            if let error = error {
                print("authentication 유저 삭제 오류: \(error)")
                completion(error)
                return
            }
            print("authentication 성공적으로 계정 삭제")
            
            let userRef = self.db.collection("users").document(user.uid)
            userRef.delete() { error in
                if let error = error {
                    print("firestore 유저 삭제 오류: \(error)")
                    completion(error)
                } else {
                    completion(nil)
                    print("firestore 성공적으로 계정 삭제")
                }
            }
        }
    }
    
    // MARK: Storage folder 삭제.
    func deleteStorageFolder(from path: String) {
        let ref = storage.reference().child(path)
        
        ref.listAll { result in
            switch result {
            case .success(let list):
                for fileRef in list.items {
                    fileRef.delete { error in
                        if let error = error {
                            print("error during delete file on storage: \(error)")
                            return
                        }
                        print("storage file deleted successfully!")
                    }
                }
            case .failure(let error):
                print("getlistAll error :\(error)")
            }
        }
    }
    
    // MARK: Post 삭제
    func deletePost(uid: String) -> Single<Void> {
        guard let user = Auth.auth().currentUser else {
            return Single.create {
                $0(.failure(UserError.logout))
                return Disposables.create()
            }
        }
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            let userRef = self.db.collection("users").document(user.uid)
            let postRef = self.db.collection("posts").document(uid)
            
            userRef.updateData(["posts" : FieldValue.arrayRemove([postRef])]) { error in
                if let error = error {
                    print("Error - Deleting Post Reference: \(error)")
                    single(.failure(error))
                    return
                }
                print("Post Reference deleted Successfully!")
                postRef.delete { error in
                    if let error = error {
                        print("Error - Deleting Post: \(error)")
                        single(.failure(error))
                        return
                    }
                    single(.success(()))
                }
            }
            return Disposables.create()
        }
    }
    
    
    func fileNameFromUrl(urlString: String) -> String {
        guard let url = URL(string: urlString) else { return "" }
        return url.lastPathComponent
    }
    
//    // 특정 포스트의 미디어 URL들을 가져오기
//    func fetchMediaForPost(postID: String, completion: @escaping (Result<[URL], Error>) -> Void) {
//        let mediaCollection = db.collection("media")
//        
//        mediaCollection.whereField("postRef", isEqualTo: "/posts/\(postID)")
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                
//                guard let snapshot = snapshot else {
//                    completion(.success([]))
//                    return
//                }
//                
//                // 각 문서에서 "url" 필드를 가져와 URL 배열로 변환
//                let urls = snapshot.documents.compactMap { document -> URL? in
//                    guard let urlString = document.get("url") as? String else { return nil }
//                    return URL(string: urlString)
//                }
//                
//                completion(.success(urls))
//            }
//    }
    
    
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
//            .limit(to: 20)
        
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
//        return Single.create { [weak self] single in
//            guard let self else { return Disposables.create() }
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
                media.postRef.getDocument { snapshot, error in
                    if let error = error {
                        print("Error - get post \(error)")
                        single(.success(nil)) // 오류 발생 시 nil 반환하여 계속 진행
                        return
                    }
                    
                    guard let data = snapshot?.data(),
                          let postUID = data["postUID"] as? String,
                          let authorUID = data["authorUID"] as? String,
//                          let creationDate = data["creationDate"] as? Date,
                          let creationDate = data["creationDate"] as? Timestamp,
//                          let mediaUID = data["mediaUID"] as? String,
                          let thumbnail = media.thumbnailURL else {
                                print("여기서 실패해용")
                              single(.success(nil))
                              return
                    }

                    let filteredPostMediaRef = self.db.collection("media").document(media.mediaUID)
                    
                    let post = Post(postUID: postUID,
                                    authorUID: authorUID,
//                                    creationDate: creationDate,
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
/*
 HTTP 변환 사용 예시
 1. UIImageView 인스턴스 생성
 let gymImageView = UIImageView()
 
 2. 이미지 URL을 가져옴 (gs:// 또는 http/https 형식 가능)
 let imageUrl = model.imageUrl // 예: "gs://your-bucket-name/path-to-image" 또는 "https://example.com/image.jpg"
 
 3. ImageConversion을 사용하여 이미지 로드
 if let imageUrl = imageUrl {
 // ImageConversion 클래스를 사용하여 이미지 로드 (gs:// URL 변환 포함)
 ImageConversion.shared.loadImage(from: imageUrl, into: gymImageView)
 } else {
 이미지 URL이 없을 때 기본 이미지 설정
 gymImageView.image = UIImage(named: "defaultImage")
 }
 */

extension Firestore {
    func getAllDocuments(from refs: [DocumentReference]) async throws -> [DocumentSnapshot] {
        try await withThrowingTaskGroup(of: DocumentSnapshot.self) { group in
            for ref in refs {
                group.addTask {
                    return try await ref.getDocument()
                }
            }
            
            var documents: [DocumentSnapshot] = []
            for try await document in group {
                documents.append(document)
            }
            return documents
        }
    }
}
