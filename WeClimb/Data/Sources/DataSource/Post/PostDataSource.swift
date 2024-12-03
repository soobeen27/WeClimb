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
    func posts(postRefs: [DocumentReference]) -> Observable<[Post]>
}

class PostDataSourceImpl: PostDataSource {
    private let db = Firestore.firestore()
    private let disposeBag = DisposeBag()
    private let storage = Storage.storage()
    
    func posts(postRefs: [DocumentReference]) -> Observable<[Post]> {
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
}
