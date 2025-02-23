//
//  UserReportRepository.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/10/25.
//
import RxSwift

protocol UserReportRepository {
    func userReport(content: String, userName: String) -> Completable
}
