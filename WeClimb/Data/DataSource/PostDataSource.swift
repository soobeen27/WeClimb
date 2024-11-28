//
//  PostDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/27/24.
//

import Foundation
import Firebase
import FirebaseStorage
import RxSwift
import UIKit

protocol PostDataSource {
    
}

class DefaultPostDataSource {
    private let db = Firestore.firestore()
    private let disposeBag = DisposeBag()
    private let storage = Storage.storage()
    
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
//    func uploadPost(user: User, caption: String?, medias: [Media]) async {
//        
//        let storageRef = storage.reference()
//        let postUID = UUID().uuidString
//        let postRef = db.collection("posts").document(postUID)
//        let creationDate = Date()
//        guard let myUID = try? FirestoreHelper.userUID() else { return }
//
//        do {
//            let batch = db.batch()
//            
//            var mediaReferences: [DocumentReference] = []
//            var thumbnails: [String] = []
//            
//            for media in medias {
//                setMedia(data: (user: user, media: media, postRef: postRef))
//                batch.setData(try Firestore.Encoder().encode(mediaData), forDocument: mediaDocRef)
//                mediaReferences.append(mediaDocRef)
//            }
//            guard let gym = medias.first?.gym else { return }
//            let post = Post(postUID: postUID,
//                            authorUID: myUID,
//                            creationDate: creationDate,
//                            caption: caption,
//                            like: nil,
//                            gym: gym,
//                            medias: mediaReferences,
//                            thumbnail: thumbnails.first ?? "",
//                            commentCount: nil
//            )
//            
//            let userRef = db.collection("users").document(myUID)
//            batch.setData(try Firestore.Encoder().encode(post), forDocument: postRef)
//            batch.updateData(["posts": FieldValue.arrayUnion([postRef])], forDocument: userRef)
//            
//            try await batch.commit()
//            
//        } catch {
//            print("업로드 중 오류 발생: \(error)")
//        }
//    }
//    
//    func uploadMedia() {
//        
//    }
//    
//    func setMedia(data: (user: User ,media: Media, postRef: DocumentReference)) async throws -> Media {
//        do {
//            guard let url = URL(string: data.media.url) else {
//                throw FuncError.wrongArgument
//            }
//            let myUID = try FirestoreHelper.userUID()
//            let fileName = url.lastPathComponent.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? url.lastPathComponent
//            let mediaRef = storage.reference().child("users/\(myUID)/\(fileName)")
//            let mediaURL = try await uploadMediaToStorage(mediaRef: mediaRef, mediaURL: url)
//            
//            let thumbnailURL = data.media.thumbnailURL ?? ""
//            
//            let mediaUID = UUID().uuidString
//            let mediaDocRef = db.collection("media").document(mediaUID)
//            
//            let mediaData = Media(
//                mediaUID: mediaUID,
//                url: mediaURL.absoluteString,
//                hold: data.media.hold,
//                grade: data.media.grade,
//                gym: data.media.gym,
//                creationDate: data.media.creationDate,
//                postRef: data.postRef,
//                thumbnailURL: thumbnailURL,
//                height: data.user.height,
//                armReach: data.user.armReach
//            )
//            return mediaData
//        } catch {
//            throw error
//        }
//    }
//    
//    func uploadMediaToStorage(mediaRef: StorageReference, mediaURL: URL) async throws -> URL {
//        try await withCheckedThrowingContinuation { continuation in
//            mediaRef.putFile(from: mediaURL, metadata: nil) { metaData, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                    return
//                }
//                
//                mediaRef.downloadURL { url, error in
//                    if let error = error {
//                        continuation.resume(throwing: error)
//                    } else if let url = url {
//                        continuation.resume(returning: url)
//                    }
//                }
//            }
//        }
//    }
}
