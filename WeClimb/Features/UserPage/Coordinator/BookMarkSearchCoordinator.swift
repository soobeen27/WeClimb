//
//  BookMarkSearchCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class BookMarkSearchCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let bookMarkSearchVC = BookMarkSearchVC()
        bookMarkSearchVC.coordinator = self
        navigationController.pushViewController(bookMarkSearchVC, animated: true)
    }
}
