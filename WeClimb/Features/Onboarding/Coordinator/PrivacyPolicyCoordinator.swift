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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let userUpdateDatasource = UserUpdateDataSourceImpl()
        var userUpdateRepository = UserUpdateRepositoryImpl(userUpdateDataSource: userUpdateDatasource)
        var userUpdateUsecase = SNSAgreeUsecaseImpl(userUpdateRepository: userUpdateRepository)
        var userUpdateVM = PrivacyPolicyImpl(usecase: userUpdateUsecase)
        var privacyPolicyVC = PrivacyPolicyVC(viewModel: userUpdateVM)
        
//        let privacyPolicyVC = PrivacyPolicyVC()
        privacyPolicyVC.coordinator = self
        navigationController.pushViewController(privacyPolicyVC, animated: true)
    }
    
    func showTermsPage(url: String) {
        guard let link = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: link)
        navigationController.present(safariVC, animated: true, completion: nil)
    }
}
