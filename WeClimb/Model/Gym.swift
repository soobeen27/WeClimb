//
//  Gym.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/8/24.
//

import Foundation

struct Gym {
    let address: String
    let grade: String
    let gymName: String
    let sector: String
    let profileImage: String?
    let additionalInfo: [String: Any]
}

struct FilterConditions {
    let holdColor: String?
    let heightRange: (Int, Int)?
    let armReachRange: (Int, Int)?
}
