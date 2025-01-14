//
//  CreatePersonalDetailCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class CreatePersonalDetailCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: OnboardingBuilder
    
    var onFinish: (() -> Void)?
    
    init(navigationController: UINavigationController, builder: OnboardingBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        let createPersonalDetailVC = builder.buildCreatePersonalDetail()
        createPersonalDetailVC.coordinator = self
        navigationController.pushViewController(createPersonalDetailVC, animated: true)
    }
    
    func finishLogin() {
        onFinish?()
    }
}
