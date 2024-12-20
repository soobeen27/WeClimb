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
        setView()
        print("혹시 들어오긴하나?")
    }
    
    private func setView() {
        self.tabBar.tintColor = UIColor.black
        self.tabBar.unselectedItemTintColor = UIColor.gray
    }
}
