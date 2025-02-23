//
//  PostFilterUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/17/25.
//
import RxSwift
import FirebaseFirestore

protocol PostFilterUseCase {
    func execute(lastSnapshot: QueryDocumentSnapshot?,
                 gymName: String,
                 grade: String?,
                 hold: String?,
                 height: [Int]?,
                 armReach: [Int]?,
                 completion: @escaping (QueryDocumentSnapshot?) -> Void) -> Single<[Post]>
}

struct PostFilterUseCaseImpl: PostFilterUseCase {
    private let postFilterRepository: PostFilterRepository
    
    init(postFilterRepository: PostFilterRepository) {
        self.postFilterRepository = postFilterRepository
    }
    
    func execute(lastSnapshot: QueryDocumentSnapshot?,
                 gymName: String,
                 grade: String?,
                 hold: String?,
                 height: [Int]?,
                 armReach: [Int]?,
                 completion: @escaping (QueryDocumentSnapshot?) -> Void) -> Single<[Post]>
    {
        postFilterRepository.getFilteredPost(lastSnapshot: lastSnapshot,
                                             gymName: gymName,
                                             grade: grade,
                                             hold: hold,
                                             height: height,
                                             armReach: armReach)
        { snapshot in
            completion(snapshot)
        }
    }
}
