//
//  ClimbingGym.swift
//  WeClimb
//
//  Created by 머성이 on 9/2/24.
//

import Foundation
import UIKit

struct Item {
    let name: String
    let progress: Float
    let itemCount: Int
    
    init(name: String, progress: Float = 0.0, itemCount: Int = 0) {
        self.name = name
        self.progress = progress
        self.itemCount = itemCount
    }
}

struct DetailItem {
    let image: UIImage?
    let description: String
    let videoCount: Int
}
