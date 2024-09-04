//
//  FirebaseManager.swift
//  WeClimb
//
//  Created by 머성이 on 9/4/24.
//

import Foundation

import FirebaseFirestore
import FirebaseStorage
import RxSwift

/// FirebaseManager: Firebase 관련 모든 기능을 담당하는 클래스
class FirebaseManager {
    
    // Firestore 데이터베이스 인스턴스
    private let db = Firestore.firestore()
    
    // Storage 인스턴스
    private let storage = Storage.storage()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Firestore (데이터베이스 관련)
    
    /// 피드 데이터를 Firestore에 업로드하는 함수
    /// - Parameter feedData: 업로드할 피드 데이터 (Dictionary 형태)
    func uploadFeed(feedData: [String: Any]) -> Single<Void> {
        return Single.create { single in
            self.db.collection("feeds").addDocument(data: feedData) { error in
                if let error = error {
                    single(.failure(error))
                } else {
                    single(.success(()))
                }
            }
            return Disposables.create()
        }
    }

    /// 피드 데이터를 Firestore에서 불러오는 함수
    /// - Returns: 불러온 피드 데이터의 DocumentSnapshot 배열
    func fetchFeeds() -> Single<[DocumentSnapshot]> {
        return Single.create { single in
            self.db.collection("feeds").getDocuments { snapshot, error in
                if let error = error {
                    single(.failure(error))
                } else if let snapshot = snapshot {
                    single(.success(snapshot.documents))
                }
            }
            return Disposables.create()
        }
    }

    /// 특정 피드 데이터를 Firestore에서 업데이트하는 함수
    /// - Parameters:
    ///   - feedID: 업데이트할 피드의 ID
    ///   - newData: 새로운 피드 데이터
    func updateFeed(feedID: String, newData: [String: Any]) -> Single<Void> {
        return Single.create { single in
            self.db.collection("feeds").document(feedID).updateData(newData) { error in
                if let error = error {
                    single(.failure(error))
                } else {
                    single(.success(()))
                }
            }
            return Disposables.create()
        }
    }

    /// 특정 피드 데이터를 Firestore에서 삭제하는 함수
    /// - Parameter feedID: 삭제할 피드의 ID
    func deleteFeed(feedID: String) -> Single<Void> {
        return Single.create { single in
            self.db.collection("feeds").document(feedID).delete() { error in
                if let error = error {
                    single(.failure(error))
                } else {
                    single(.success(()))
                }
            }
            return Disposables.create()
        }
    }

    /// 암장 정보를 Firestore에서 불러오는 함수
    /// - Returns: 불러온 암장 정보의 DocumentSnapshot 배열
    func fetchClimbingGymInfo() -> Single<[DocumentSnapshot]> {
        return Single.create { single in
            self.db.collection("gyms").getDocuments { snapshot, error in
                if let error = error {
                    single(.failure(error))
                } else if let snapshot = snapshot {
                    single(.success(snapshot.documents))
                }
            }
            return Disposables.create()
        }
    }

    // MARK: - Firebase Storage (파일 관련)
    
    /// 사용자 프로필 이미지를 Firebase Storage에 업로드하는 함수
    /// - Parameter image: 업로드할 UIImage
    /// - Returns: 업로드된 이미지의 URL 문자열
    func uploadProfileImage(image: UIImage) -> Single<String> {
        return Single.create { single in
            let storageRef = self.storage.reference().child("profile_images/\(UUID().uuidString).jpg")
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                single(.failure(NSError(domain: "Image Error", code: -1, userInfo: nil)))
                return Disposables.create()
            }
            
            let uploadTask = storageRef.putData(imageData)
            uploadTask.observe(.success) { _ in
                storageRef.downloadURL { url, error in
                    if let error = error {
                        single(.failure(error))
                    } else if let url = url {
                        single(.success(url.absoluteString))
                    }
                }
            }
            uploadTask.observe(.failure) { snapshot in
                if let error = snapshot.error {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    // MARK: - 팔로우/언팔로우 기능
    
    /// 사용자를 팔로우하는 함수
    /// - Parameters:
    ///   - currentUserID: 팔로우하는 사용자 ID
    ///   - targetUserID: 팔로우 대상 사용자 ID
    func followUser(currentUserID: String, targetUserID: String) -> Single<Void> {
        return Single.create { single in
            self.db.collection("users").document(currentUserID).collection("following").document(targetUserID).setData([:]) { error in
                if let error = error {
                    single(.failure(error))
                } else {
                    single(.success(()))
                }
            }
            return Disposables.create()
        }
    }

    /// 사용자를 언팔로우하는 함수
    /// - Parameters:
    ///   - currentUserID: 언팔로우하는 사용자 ID
    ///   - targetUserID: 언팔로우 대상 사용자 ID
    func unfollowUser(currentUserID: String, targetUserID: String) -> Single<Void> {
        return Single.create { single in
            self.db.collection("users").document(currentUserID).collection("following").document(targetUserID).delete() { error in
                if let error = error {
                    single(.failure(error))
                } else {
                    single(.success(()))
                }
            }
            return Disposables.create()
        }
    }

    // MARK: - 신고 기능
    
    /// 컨텐츠를 신고하는 함수
    /// - Parameters:
    ///   - reporterID: 신고한 사용자 ID
    ///   - reportedContentID: 신고된 컨텐츠의 ID
    ///   - reason: 신고 이유
    func reportContent(reporterID: String, reportedContentID: String, reason: String) -> Single<Void> {
        return Single.create { single in
            let reportData: [String: Any] = [
                "reporterID": reporterID,
                "reportedContentID": reportedContentID,
                "reason": reason,
                "timestamp": Timestamp()
            ]
            self.db.collection("reports").addDocument(data: reportData) { error in
                if let error = error {
                    single(.failure(error))
                } else {
                    single(.success(()))
                }
            }
            return Disposables.create()
        }
    }
}
