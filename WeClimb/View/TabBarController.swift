//
//  TabBarController.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit
import FirebaseAuth

class TabBarController: UITabBarController {
    
    private let viewModel = MyPageVM()
    var myPage: UIViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sfMainFeedVC = UINavigationController(rootViewController: SFMainFeedVC())
        let searchVC = UINavigationController(rootViewController: SearchVC())
        let uploadVC = UINavigationController(rootViewController: UploadVC())
        
        sfMainFeedVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: nil)
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        uploadVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: nil)
        
        let myPageVC: UIViewController
        if Auth.auth().currentUser != nil {
            myPageVC = UINavigationController(rootViewController: MyPageVC())
            myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        } else {
            myPageVC = UINavigationController(rootViewController: GuestVC())
            myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        }
        self.setViewControllers([sfMainFeedVC, searchVC, uploadVC, myPageVC], animated: true)
        
    }
}
