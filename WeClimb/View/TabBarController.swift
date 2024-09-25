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
        
        sfMainFeedVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: nil)
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        
        let myPageVC: UIViewController
        let uploadVC: UIViewController
        if Auth.auth().currentUser != nil {
            myPageVC = UINavigationController(rootViewController: MyPageVC())
            myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
            
            uploadVC = UINavigationController(rootViewController: UploadVC())
            uploadVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: nil)
        } else {
            myPageVC = UINavigationController(rootViewController: GuestVC())
            myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
            
            uploadVC = UINavigationController(rootViewController: GuestVC())
            uploadVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: nil)
        }
        self.setViewControllers([sfMainFeedVC, searchVC, uploadVC, myPageVC], animated: true)
        
    }
}
