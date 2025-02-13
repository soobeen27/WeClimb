//
//  UserReportDataSource.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/10/25.
//
import RxSwift
import FirebaseFirestore

protocol UserReportDataSource {
    func userReport(content: String, userName: String) -> Completable
}

class UserReportDataSourceImpl: UserReportDataSource {
    private let db = Firestore.firestore()
    
    func userReport(content: String, userName: String) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else {
                completable(.error(CommonError.selfNil))
                return Disposables.create()
            }
            let userReport: [String: Any] = [
                "content": content,
                "userName": userName,
                "time": Timestamp()
            ]
            
            db.collection("report").addDocument(data: userReport) { error in
                if let error = error {
                    print("Firestore 오류 발생: \(error.localizedDescription)")
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
            }
            return Disposables.create()
        }
    }
}
