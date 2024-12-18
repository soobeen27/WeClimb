//
//  AppCoordinator.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

protocol Coordinator {
    
}

final class AppCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinates: [Coordinator] = []
    public let appDIcontainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIcontainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIcontainer = appDIcontainer
    }
    
    func start() {
        
    }
}
