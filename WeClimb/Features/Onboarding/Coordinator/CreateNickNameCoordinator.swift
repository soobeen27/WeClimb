//
//  CreateNickNameCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class CreateNickNameCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: OnboardingBuilder
    
    var onFinish: (() -> Void)?
    
    init(navigationController: UINavigationController, builder: OnboardingBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        showCreateNickname()
    }
    
    private func showCreateNickname() {
        let createNicknameVC = builder.buildCreateNickname()
        createNicknameVC.coordinator = self
        createNicknameVC.onCreateNickname = { [weak self] in
            self?.onFinish?()
        }
        
        navigationController.pushViewController(createNicknameVC, animated: true)
    }
}
