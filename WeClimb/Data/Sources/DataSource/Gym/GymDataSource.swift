//
//  GymDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/28/24.
//

import Foundation
import Firebase
import RxSwift

protocol GymDataSource {
    func gymInfo(gymName: String) -> Single<Gym>
    func allGymInfo() -> Single<[Gym]>
    func searchGyms(with query: String) -> Observable<[Gym]>
}

class GymDataSourceImpl: GymDataSource {
    private let db = Firestore.firestore()
    
    func gymInfo(gymName: String) -> Single<Gym> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CommonError.selfNil))
                return Disposables.create()
            }
            self.db.collection("climbingGyms").document(gymName)
                .getDocument { snapShot, error in
                    if let error {
                        single(.failure(error))
                        return
                    }
                    guard let snapShot else {
                        single(.failure(FirebaseError.documentNil))
                        return
                    }
                    do {
                        let gym = try self.gymDecode(document: snapShot)
                        single(.success(gym))
                    } catch {
                        single(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }

    func allGymInfo() -> Single<[Gym]> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CommonError.selfNil))
                return Disposables.create()
            }
            self.db.collection("climbingGyms").getDocuments { snapshot, error in
                if let error {
                    single(.failure(error))
                    return
                }
                guard let snapshot else {
                    single(.failure(FirebaseError.documentNil))
                    return
                }
                let gyms = snapshot.documents.compactMap { qDocument in
                    return self.gymDecode(queryDocument: qDocument)
                }
                single(.success(gyms))
            }
            return Disposables.create()
        }
    }
    
    private func gymDecode(queryDocument: QueryDocumentSnapshot) -> Gym? {
        let data = queryDocument.data()
        guard let address = data["address"] as? String,
              let grade = data["grade"] as? String,
              let gymName = data["gymName"] as? String,
              let sector = data["sector"] as? String,
              let profileImage = data["profileImage"] as? String
        else {
            return nil
        }
        var additionalInfo = data
        additionalInfo.removeValue(forKey: "address")
        additionalInfo.removeValue(forKey: "grade")
        additionalInfo.removeValue(forKey: "gymName")
        additionalInfo.removeValue(forKey: "sector")
        additionalInfo.removeValue(forKey: "profileImage")
        
        return Gym(
            address: address, grade: grade,
            gymName: gymName, sector: sector,
            profileImage: profileImage, additionalInfo: additionalInfo
        )
    }
    
    private func gymDecode(document: DocumentSnapshot) throws -> Gym {
        guard let data = document.data() else {
            throw FirebaseError.documentNil
        }
        guard let address = data["address"] as? String,
              let grade = data["grade"] as? String,
              let gymName = data["gymName"] as? String,
              let sector = data["sector"] as? String,
              let profileImage = data["profileImage"] as? String
        else {
            throw FirebaseError.nonRequiredInfo
        }
        var additionalInfo = data
        additionalInfo.removeValue(forKey: "address")
        additionalInfo.removeValue(forKey: "grade")
        additionalInfo.removeValue(forKey: "gymName")
        additionalInfo.removeValue(forKey: "sector")
        additionalInfo.removeValue(forKey: "profileImage")
        
        return Gym(
            address: address, grade: grade,
            gymName: gymName, sector: sector,
            profileImage: profileImage, additionalInfo: additionalInfo
        )
    }
    
    func searchGyms(with query: String) -> Observable<[Gym]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onNext([])
                observer.onCompleted()
                return Disposables.create()
            }

            let queryStart = query
            let queryEnd = query + "\u{f8ff}"

            self.db.collection("climbingGyms")
                .whereField("gymName", isGreaterThanOrEqualTo: queryStart)
                .whereField("gymName", isLessThanOrEqualTo: queryEnd)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }

                    guard let snapshot = snapshot else {
                        observer.onNext([])
                        observer.onCompleted()
                        return
                    }

                    let gyms = snapshot.documents.compactMap { document in
                        return self.gymDecode(queryDocument: document)
                    }

                    observer.onNext(gyms)
                }

            return Disposables.create()
        }
    }

}
