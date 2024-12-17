//
//  DataError.swift
//  WeClimb
//
//  Created by 머성이 on 12/4/24.
//

import Foundation

enum AppError: Error {
    case unknown
    case firebaseError(FirebaseError)
    
    var description: String {
        switch self {
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        case .firebaseError(let error):
            return error.description
        }
    }
}

enum FirebaseError: Error {
    case documentNil
    case firestoreFailure(String)
    case nonRequiredInfo
    
    var description: String {
        switch self {
        case .documentNil:
            return "도큐멘트를 찾을 수 없습니다."
        case .firestoreFailure(let message):
            return "Firestore 작업 실패: \(message)"
        case .nonRequiredInfo:
            return "비필수 정보"
        }
    }
}

enum UserStateError: Error {
    case notAuthenticated
    case missingURL
    case nonmember
    
    var localizedDescription: String {
        switch self {
        case .notAuthenticated:
            return "사용자가 인증되지 않았습니다."
        case .missingURL:
            return "업로드된 이미지의 URL을 가져오지 못했습니다."
        case .nonmember:
            return "비회원 입니다."
        }
    }
}

enum FuncError: Error {
    case wrongArgument
    case unknown
    
    var description: String {
        switch self {
        case .wrongArgument:
            return "잘못된 인자가 전달되었습니다."
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}

enum NetworkError: Error {
    case dataNil

    var description: String {
        switch self {
        case .dataNil:
            return "네트워크에서 데이터를 받을 수 없습니다."
        }
    }
}

enum CommonError: Error {
    case selfNil

    var description: String {
        switch self {
        case .selfNil:
            return "self가 nil입니다. 예상치 못한 참조 오류가 발생했습니다."
        }
    }
}
