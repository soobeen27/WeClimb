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

protocol UploadPostDataSource {
    func uploadPost(user: User, gym: String?, caption: String?,
                    datas: [(url: URL, hold: String?, grade: String?, thumbnailURL: URL?)]) -> Completable
}

class UploadPostDataSourceImpl {

    private let db = Firestore.firestore()
    private let disposebag = DisposeBag()
    
    func uploadPost(user: User, gym: String?, caption: String?,
                    datas: [(url: URL, hold: String?, grade: String?, thumbnailURL: URL?)]) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else {
                completable(.error(CommonError.selfNil))
                return Disposables.create()
            }
            guard let authorUID = try? FirestoreHelper.userUID() else {
                completable(.error(UserStateError.nonmeber))
                return Disposables.create()
            }
            let creationDate = Date()
            mediasUpload(user: user, gym: gym, datas: datas)
                .subscribe(onSuccess: { [weak self] references, batch in
                    guard let self else {
                        completable(.error(UserStateError.nonmeber))
                        return
                    }
                    do {
                        let postUID = UUID().uuidString
                        let postRef = self.db.collection("posts").document(postUID)
                        let post = Post(postUID: postUID,
                                        authorUID: authorUID,
                                        creationDate: creationDate,
                                        caption: caption,
                                        like: nil,
                                        gym: gym,
                                        medias: references,
                                        thumbnail: datas.first?.thumbnailURL?.absoluteString,
                                        commentCount: nil)
                        try self.createPost(batch: batch, post: post, postRef: postRef)
                        self.userUpdatePost(batch: batch, postRef: postRef, userUID: authorUID)
                        self.mediaUpdate(batch: batch, postRef: postRef, mediaRefs: references)
                        batch.commit { error in
                            if let error {
                                completable(.error(error))
                            } else {
                                completable(.completed)
                            }
                        }
                    } catch {
                        completable(.error(error))
                    }
                }, onFailure: { error in
                    completable(.error(error))
                })
                .disposed(by: disposebag)
            
            return Disposables.create()
        }
    }
    
    private func createPost(batch: WriteBatch, post: Post, postRef: DocumentReference) throws {
        let encodedPost = try Firestore.Encoder().encode(post)
        batch.setData(encodedPost, forDocument: postRef)
    }
    
    private func userUpdatePost(batch: WriteBatch, postRef: DocumentReference, userUID: String) {
        let userRef = db.collection("users").document(userUID)
        batch.updateData(["posts": FieldValue.arrayUnion([postRef])], forDocument: userRef)
    }
    
    private func mediaUpdate(batch: WriteBatch, postRef: DocumentReference, mediaRefs: [DocumentReference]) {
        mediaRefs.forEach { reference in
            batch.updateData(["postRef" : postRef], forDocument: reference)
        }
    }
    
    private func mediasUpload(user: User, gym: String?, datas: [(url: URL, hold: String?, grade: String?, thumbnailURL: URL?)]) -> Single<(references: [DocumentReference], batch: WriteBatch )> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CommonError.selfNil))
                return Disposables.create()
            }
            let batch = db.batch()
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
                                batch.setData(encodedMedia, forDocument: mediaDocRef)
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
                    single(.success((sortedRefs, batch)))
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
