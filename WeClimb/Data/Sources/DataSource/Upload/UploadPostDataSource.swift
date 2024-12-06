//
//  UploadPostDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/29/24.
//

import Foundation
import RxSwift
import Firebase
import FirebaseStorage
// 업로드용
struct PostUploadData {
    let user: User
    let gym: String?
    let caption: String?
    let medias: [MediaUploadData]
}

struct MediaUploadData {
    let url: URL
    let hold: String?
    let grade: String?
    let thumbnailURL: URL?
}

protocol UploadPostDataSource {
    func uploadPost(data: PostUploadData) -> Completable
}

class UploadPostDataSourceImpl: UploadPostDataSource {

    private let db = Firestore.firestore()
    private var disposebag = DisposeBag()
    private var postUID: String
    private var postRef: DocumentReference
    private var batch: WriteBatch
    
    init() {
        self.batch = db.batch()
        self.postUID = UUID().uuidString
        self.postRef = db.collection("posts").document(postUID)
    }
    
    func uploadPost(data: PostUploadData) -> Completable {
        batch = db.batch()
        disposebag = DisposeBag()
        return mediasUpload(user: data.user, gym: data.gym, datas: data.medias)
            .flatMapCompletable { [weak self] references in
                guard let self else { return Completable.error(CommonError.selfNil) }
                do {
                    let creationDate = Date()
                    let authorUID = try FirestoreHelper.userUID()
                    let post = Post(postUID: self.postUID,
                                    authorUID: authorUID,
                                    creationDate: creationDate,
                                    caption: data.caption,
                                    like: nil,
                                    gym: data.gym,
                                    medias: references,
                                    thumbnail: data.medias.first?.thumbnailURL?.absoluteString,
                                    commentCount: nil)
                    try self.createPost(post: post)
                    self.userUpdatePost(userUID: authorUID)
                    self.mediaUpdate(mediaRefs: references)
                    
                    return self.commitBatch()
                } catch {
                    return Completable.error(error)
                }
            }
    }
    
    private func commitBatch() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else {
                completable(.error(CommonError.selfNil))
                return Disposables.create()
            }
            self.batch.commit { error in
                if let error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
            }
            return Disposables.create()
        }
    }
    
    private func createPost(post: Post) throws {
        let encodedPost = try Firestore.Encoder().encode(post)
        batch.setData(encodedPost, forDocument: postRef)
    }
    
    private func userUpdatePost(userUID: String) {
        let userRef = db.collection("users").document(userUID)
        batch.updateData(["posts": FieldValue.arrayUnion([postRef])], forDocument: userRef)
    }
    
    private func mediaUpdate(mediaRefs: [DocumentReference]) {
        mediaRefs.forEach { reference in
            batch.updateData(["postRef" : postRef], forDocument: reference)
        }
    }
    
    private func mediasUpload(user: User, gym: String?, datas: [MediaUploadData]) -> Single<[DocumentReference]> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CommonError.selfNil))
                return Disposables.create()
            }
            let creationDate = Date()
            
            let uploadTasks = datas.enumerated().map { index, data -> Single<(Int, DocumentReference)> in
                return self.mediaUploadStoage(mediaURL: data.url)
                    .flatMap { url -> Single<(Int, DocumentReference)> in
                        Single.create { single in
                            let mediaUID = UUID().uuidString
                            let mediaDocRef = self.db.collection("media").document(mediaUID)
                            
                            let mediaData = Media(
                                mediaUID: mediaUID,
                                url: url.absoluteString,
                                hold: data.hold,
                                grade: data.grade,
                                gym: gym,
                                creationDate: creationDate,
                                postRef: nil,
                                thumbnailURL: data.thumbnailURL?.absoluteString,
                                height: user.height,
                                armReach: user.armReach
                            )
                            
                            do {
                                let encodedMedia = try Firestore.Encoder().encode(mediaData)
                                self.batch.setData(encodedMedia, forDocument: mediaDocRef)
                                single(.success((index, mediaDocRef)))
                            } catch {
                                single(.failure(error))
                            }
                            
                            return Disposables.create()
                        }
                    }
            }
            
            Single.zip(uploadTasks)
                .map { results -> [DocumentReference] in
                    results.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
                }
                .subscribe(onSuccess: { sortedRefs in
                    single(.success(sortedRefs))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: disposebag)
            
            return Disposables.create()
        }
    }
    
    private func mediaUploadStoage(mediaURL: URL) -> Single<URL> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            do {
                let fileName = self.mediaStorageFileName(mediaURL: mediaURL)
                let mediaStorageRef = try self.mediaStorageRef(fileName: fileName)
                let uploadTask = mediaStorageRef.putFile(from: mediaURL) { metadata, error in
                    if let error {
                        single(.failure(error))
                    }
                }
                uploadTask.observe(.success) { snapshot in
                    mediaStorageRef.downloadURL { url, error in
                        if let error = error {
                            single(.failure(error))
                            return
                        } else if let url {
                            single(.success(url))
                        }
                    }
                }
                uploadTask.resume()
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    private func mediaStorageFileName(mediaURL: URL) -> String {
        let fileName = mediaURL.lastPathComponent
            .addingPercentEncoding(withAllowedCharacters:
                                    CharacterSet.urlPathAllowed) ?? mediaURL.lastPathComponent
        return fileName
    }
    
    private func mediaStorageRef(fileName: String) throws -> StorageReference {
        do {
            let myUID = try FirestoreHelper.userUID()
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let mediaRef = storageRef.child("users/\(myUID)/\(fileName)")
            return mediaRef
        } catch {
            throw error
        }
    }
}
