//
//  GymProfileCoordinator.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/18/25.
//

import UIKit

final class GymProfileCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: GymBuilder
    
    var onFinish: (() -> Void)?
    
    init(navigationController: UINavigationController, builder: GymBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func start(gymName: String, level: LHColors?, hold: LHColors?) {
        showGymProfile(gymName: gymName, level: level, hold: hold)
    }
    
    func showGymProfile(gymName: String, level: LHColors?, hold: LHColors?) {
        let gymProfileVC = builder.buildGymProfile(gymName: gymName, level: level, hold: hold)
        gymProfileVC.coordinator = self
        navigationController.pushViewController(gymProfileVC, animated: true)
    }

}

