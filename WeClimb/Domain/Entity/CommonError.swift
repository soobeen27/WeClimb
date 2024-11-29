//
//  CommonError.swift
//  WeClimb
//
//  Created by Soobeen Jang on 11/29/24.
//

import Foundation

enum CommonError: Error {
    case selfNil
    case unknown
    
    var description: String {
        switch self {
        case .selfNil:
            "self is nil"
        case .unknown:
            "unknown error"
        }
    }
}
