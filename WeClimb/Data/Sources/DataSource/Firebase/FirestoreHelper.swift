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

final class FirestoreHelper {
    
    static func userUID() throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw UserStateError.nonmember
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
