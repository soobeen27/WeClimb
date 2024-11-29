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
    
}

class UploadPostDataSourceImpl {
    //미디어 올리기 -> 미디어 레퍼런스
    //포스트 올리기 -> 포스트 레퍼런스
    //포스트 업데이트
    //미디어 업데이트
    //업로드
    private let db = Firestore.firestore()
    private let disposebag = DisposeBag()
    
    private func mediasUpload(user: User, gym: String?, datas: [(url: URL, hold: String?, grade: String?, thumbnailURL: URL)]) -> Single<[DocumentReference]> {
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
                                thumbnailURL: data.thumbnailURL.absoluteString,
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
                    results.sorted(by: { $0.0 < $1.0 }).map { $0.1 } // 인덱스 기준으로 정렬
                }
                .subscribe(onSuccess: { sortedRefs in
                    batch.commit { error in
                        if let error = error {
                            single(.failure(error))
                            return
                        }
                        single(.success(sortedRefs))
                    }
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
            let mediaRef = storageRef.child("(users/\(myUID)/\(fileName)")
            return mediaRef
        } catch {
            throw error
        }
    }
}
