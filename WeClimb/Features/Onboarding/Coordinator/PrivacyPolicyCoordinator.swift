//
//  PrivacyPolicyCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit
import SafariServices

final class PrivacyPolicyCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: OnboardingBuilder
    
    var onFinish: (() -> Void)?
    
    init(navigationController: UINavigationController, builder: OnboardingBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        showPrivacyPolicy()
    }
    
    private func showPrivacyPolicy() {
        let privacyPolicyVC = builder.buildPrivacyPolicy()
        privacyPolicyVC.coordinator = self
        privacyPolicyVC.onTermsAgreed = { [weak self] in
            self?.onFinish?()
        }
        
        navigationController.pushViewController(privacyPolicyVC, animated: true)
    }
    
    func showTermsPage(url: String) {
        guard let link = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: link)
        navigationController.present(safariVC, animated: true, completion: nil)
    }
}
