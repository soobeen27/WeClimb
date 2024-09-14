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
import FirebaseStorage
import FirebaseFirestore
import FirebaseStorage
import GoogleSignIn
import RxSwift
import Kingfisher

                
final class FirebaseManager {
 
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let disposeBag = DisposeBag()
    
    static let shared = FirebaseManager()
    private init() {}
    
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
        guard let user = Auth.auth().currentUser else { return }
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

    // MARK: 이름으로 다른 유저 정보 가져오기
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
    
    // MARK: 로그인된 계정 삭제
    func userDelete() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete() { error in
            if let error = error {
                print("authentication 유저 삭제 오류: \(error)")
            }
            else {
                print("authentication 성공적으로 계정 삭제")
            }
        }
        
        let userRef = db.collection("users").document(user.uid)
        userRef.delete() { error in
            if let error = error {
                print("firestore 유저 삭제 오류: \(error)")
            } else {
                print("firestore 성공적으로 계정 삭제")
            }
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
    func uploadPost(media: [URL], caption: String) {
        guard let user = Auth.auth().currentUser else {
            print("로그인이 되지않음")
            return
        }
        
        let storageRef = storage.reference()
        
        let uploadedMedia = media.enumerated().map { index, url -> Observable<(Int, String)> in
            let fileName = url.lastPathComponent
            let mediaRef = storageRef.child("users/\(user.uid)/\(fileName)")

            return Observable<(Int, String)>.create { observer in
                mediaRef.putFile(from: url, metadata: nil) { metaData, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    mediaRef.downloadURL { url, error in
                        if let error = error {
                            observer.onError(error)
                            return
                        }
                        guard let url = url else { return }
                        observer.onNext((index, url.absoluteString))
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
        Observable.zip(uploadedMedia)
            .subscribe(onNext: { [weak self] userMedia in
                guard let self else { return }
                let sortedUserMedia = userMedia.sorted(by: { $0.0 < $1.0}).map { $0.1 }
                let formatter = DateFormatter()
                formatter.dateFormat = "yyMMddHHmmss"
                let stringDate = formatter.string(from: Date())
                let userRef = self.db.collection("users").document(user.uid).collection("posts").document(stringDate)
                
                do {
                    try userRef.setData(from: Post(postUID: UUID().uuidString, creationDate: Date(), caption: caption, medias: sortedUserMedia, like: 0))
                    print("게시글 올리기 성공!")
                } catch {
                    print("게시글 올리기 오류")
                }
                
            }, onError: { error in
                print("업로드중 오류 발생: \(error)")
            }).disposed(by: disposeBag)
    }
    // MARK: 댓글달기
    func addComment(fromPostUid postUid: String, postOwnerUid: String, text: String) {
        guard let user = Auth.auth().currentUser else {
            print("로그인이 되지않음")
            return
        }
        let commentUID = UUID().uuidString
        let postRef = db.collection("users").document(postOwnerUid).collection("posts").document(postUid).collection("comments").document(commentUID)
        do {
            try postRef.setData(from: Comment(commentUID: commentUID,text: text, from: user.uid, creationDate: Date(), like: 0))
        } catch {
            print("댓글 작성중 에러")
        }
    }
    
    // MARK: 내 포스트 가져오기 최신순
    func allMyPost(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("로그인 되지 않았음")
            return
        }
        let postsRef = db.collection("users").document(user.uid).collection("posts")
        
        postsRef.getDocuments { snapshot, error in
            if let error = error {
                print("내 포스트 가져오는중 에러: \(error)")
                return
            }
            guard let documents = snapshot?.documents else {
                completion(.failure(PostError.none))
                return
            }
            
            var posts: [Post] = documents.compactMap { document in
                do {
                    return try document.data(as: Post.self)
                } catch {
                    print("포스트 매핑중 오류")
                    return nil
                }
            }
            if posts.isEmpty {
                completion(.failure(PostError.none))
            } else {
                let sortedPosts = posts.sorted(by: { $0.creationDate > $1.creationDate})
                completion(.success(sortedPosts))
            }
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
    
    
    // MARK: - DS 작업 (유저 신고, HTTP 변환)
//     유저 신고내역
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
        let storageReference = storage.reference(forURL: gsURL)
        
        storageReference.downloadURL { url, error in
            if let error = error {
                print("Error converting gsURL to httpsURL: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(url)
        }
    }
    
    // Kingfisher를 사용하여 이미지 로드하는 함수 (gs:// 및 http/https URL 모두 처리)
    func loadImage(from imageUrl: String?, into imageView: UIImageView) {
        guard let imageUrl = imageUrl else {
            imageView.image = UIImage(named: "defaultImage")
            return
        }

        if imageUrl.hasPrefix("gs://") {
            // gs:// URL을 HTTPS로 변환 후 이미지 로드
            fetchImageURL(from: imageUrl) { httpsURL in
                self.setImage(with: httpsURL, into: imageView)
            }
        } else {
            // HTTP/HTTPS URL 처리
            let url = URL(string: imageUrl)
            setImage(with: url, into: imageView)
        }
    }
    
    // Kingfisher로 이미지를 설정하는 함수
    private func setImage(with url: URL?, into imageView: UIImageView) {
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
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
}
