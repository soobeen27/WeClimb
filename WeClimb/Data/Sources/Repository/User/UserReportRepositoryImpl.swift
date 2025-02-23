//
//  UserReportRepositoryImpl.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/10/25.
//
import RxSwift

class UserReportRepositoryImpl: UserReportRepository {
    private let userReportDataSource: UserReportDataSource
    
    init(userReportDataSource: UserReportDataSource) {
        self.userReportDataSource = userReportDataSource
    }
    
    func userReport(content: String, userName: String) -> Completable {
        userReportDataSource.userReport(content: content, userName: userName)
    }
}
