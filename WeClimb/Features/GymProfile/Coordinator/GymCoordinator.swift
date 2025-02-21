//
//  GymCoordinator.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/18/25.
//

import UIKit

final class GymCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: GymProfileBuilder
    
    init(navigationController: UINavigationController, builder: GymProfileBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {

    }
}
