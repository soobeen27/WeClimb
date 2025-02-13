//
//  UserReportUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/10/25.
//
import RxSwift

protocol UserReportUseCase {
    func execute(content: String, userName: String) -> Completable
}

struct UserReportUseCaseImpl: UserReportUseCase {
    private let userReportRepository: UserReportRepository
    
    init(userReportRepository: UserReportRepository) {
        self.userReportRepository = userReportRepository
    }
    
    func execute(content: String, userName: String) -> Completable {
        userReportRepository.userReport(content: content, userName: userName)
    }
}
