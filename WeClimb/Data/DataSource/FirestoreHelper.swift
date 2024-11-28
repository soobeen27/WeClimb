//
//  FirestoreHelper.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/27/24.
//
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFunctions
import FirebaseStorage
import RxSwift

enum UserStateError: Error {
    case nonmeber
    case unknown
    
    var description: String {
        switch self {
        case .nonmeber: "비회원입니다"
        case .unknown: "알수없는 에러"
        }
    }
}

final class FirestoreHelper {
    
    static func userUID() throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw UserStateError.nonmeber
        }
        return user.uid
    }
    
    static func getAllDocuments(from refs: [DocumentReference]) async throws -> [DocumentSnapshot] {
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
