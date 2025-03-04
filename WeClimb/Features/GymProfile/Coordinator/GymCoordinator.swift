//
//  GymCoordinator.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/18/25.
//

import UIKit

final class GymCoordinator: BaseCoordinator {
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
    
    private func showGymProfile(gymName: String, level: LHColors?, hold: LHColors?) {
        let gymProfileCoordinator = GymProfileCoordinator(navigationController: navigationController, builder: builder)
        addDependency(gymProfileCoordinator)
        
        gymProfileCoordinator.start(gymName: gymName, level: level, hold: hold)
        
        gymProfileCoordinator.onFinish = { [weak self] in
            self?.onFinish?()
        }
    }
}
