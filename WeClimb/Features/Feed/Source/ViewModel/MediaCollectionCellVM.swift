//
//  MediaCollectionCellVM.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/21/25.
//

import RxSwift

import FirebaseFirestore

protocol MediaCollectionCellInput {
    var mediaPath: String { get }
}

protocol MediaCollectionCellOutput {
    var mediaItem: Single<Media> { get }
}

protocol MediaCollectionCellVM {
    func transform(input: MediaCollectionCellInput) -> MediaCollectionCellOutput
}

class MediaCollectionCellVMImpl: MediaCollectionCellVM {

    private let fetchMediaUseCase: FetchMediaUseCase
    
    struct Input: MediaCollectionCellInput {
        var mediaPath: String
    }
    
    struct Output: MediaCollectionCellOutput {
        var mediaItem: Single<Media>
    }
    
    init(fetchMediaUseCase: FetchMediaUseCase) {
        self.fetchMediaUseCase = fetchMediaUseCase
    }
    
    func transform(input: MediaCollectionCellInput) -> MediaCollectionCellOutput {
        let ref = pathToRef(path: input.mediaPath)
        return Output(mediaItem: fetchMediaUseCase.execute(ref: ref))
    }
    
    private func pathToRef(path: String) -> DocumentReference {
        return Firestore.firestore().document(path)
    }
 
}
