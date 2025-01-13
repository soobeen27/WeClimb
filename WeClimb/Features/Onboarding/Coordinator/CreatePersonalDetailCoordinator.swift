//
//  CreatePersonalDetailCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class CreatePersonalDetailCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        // 1. DataSource 생성
        let userUpdateDataSource = UserUpdateDataSourceImpl()
        let userReadDataSource = UserReadDataSourceImpl()
        
        // 2. Repository 생성
        let userUpdateRepository = UserUpdateRepositoryImpl(userUpdateDataSource: userUpdateDataSource)
        
        // 3. UseCase 생성
        let personalDetailUseCase = PersonalDetailUseCaseImpl(userUpdateRepository: userUpdateRepository)
        
        // 4. ViewModel 생성
        let createPersonalDetailVM = CreatePersonalDetailImpl(
            
            updateUseCase: personalDetailUseCase
        )
        
        // 5. ViewController 생성
        let createPersonalDetailVC = CreatePersonalDetailVC(viewModel: createPersonalDetailVM)
        
//        let createPersonalDetailVC = CreatePersonalDetailVC()
        createPersonalDetailVC.coordinator = self
        navigationController.pushViewController(createPersonalDetailVC, animated: true)
    }
}
