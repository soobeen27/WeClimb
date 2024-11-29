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
    
}

class GymDataSourceImpl {
    private let db = Firestore.firestore()
    
    func allGymName() -> Single<[String]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            self.db.collection("climbingGyms").getDocuments { snapshot, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let documents = snapshot?.documents else {
                    single(.failure(NetworkError.dataNil))
                    return
                }
                let documentNames = documents.map {
                    $0.documentID
                }
                single(.success(documentNames))
            }
            return Disposables.create()
        }
    }
    
    func gymInfo(from name: String, completion: @escaping (Gym?) -> Void) {
        db.collection("climbingGyms")
            .document(name)
            .getDocument { document, error in
                if let error = error {
                    print("암장 정보 가져오기 에러: \(error)")
                    completion(nil)
                    return
                }
                guard let document = document, document.exists,
                      let data = document.data()
                else {
                    print("정보없음")
                    completion(nil)
                    return
                }
                guard let address = data["address"] as? String,
                      let grade = data["grade"] as? String,
                      let gymName = data["gymName"] as? String,
                      let sector = data["sector"] as? String,
                      let profileImage = data["profileImage"] as? String
                else {
                    print("필수 정보 없음")
                    completion(nil)
                    return
                }
                var additionalInfo = data
                additionalInfo.removeValue(forKey: "address")
                additionalInfo.removeValue(forKey: "grade")
                additionalInfo.removeValue(forKey: "gymName")
                additionalInfo.removeValue(forKey: "sector")
                additionalInfo.removeValue(forKey: "profileImage")
                
                completion(Gym(address: address, grade: grade,
                               gymName: gymName, sector: sector,
                               profileImage: profileImage, additionalInfo: additionalInfo))
            }
    }

}
