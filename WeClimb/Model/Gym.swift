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
    var holdColor: String?
    var heightRange: (Int, Int)?
    var armReachRange: (Int, Int)?
}
