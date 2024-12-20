//
//  TabBarVC.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

class TabBarVC: UITabBarController {
    var coordinator: TabBarCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setView()
    }
    
    private func setView() {
        updateTabBarTintColor(selectedIndex: self.selectedIndex)
    }
}

extension TabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateTabBarTintColor(selectedIndex: tabBarController.selectedIndex)
    }
    
    private func updateTabBarTintColor(selectedIndex: Int) {
        switch self.selectedIndex {
        case 0, 2:
            self.tabBar.tintColor = UIColor.white
        case 1, 3, 4:
            self.tabBar.tintColor = UIColor.black
        default:
            self.tabBar.tintColor = UIColor.black
        }
        self.tabBar.unselectedItemTintColor = UIColor.gray
    }
}
