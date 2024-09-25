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
        //                let mypageRootVC = UINavigationController(rootViewController: myPageVC)
        
        sfMainFeedVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: nil)
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        uploadVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: nil)
        //            mypageRootVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        
        // 로그인 상태 체크
        //        viewModel.checkUserStatus { [weak self] isLoggedIn in
        //            guard let self = self else { return }
        //
        //            let myPageVC: UIViewController
        //            if isLoggedIn {
        //                myPageVC = UINavigationController(rootViewController: MyPageVC())
        //                myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        //            } else {
        //                myPageVC = UINavigationController(rootViewController: GuestVC())
        //                myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        //            }
        //
        //            DispatchQueue.main.async {
        //                self.setViewControllers([sfMainFeedVC, searchVC, uploadVC, myPage], animated: true)
        //            }
        //        }
        
        let myPageVC: UIViewController
        if let user = Auth.auth().currentUser {
            myPageVC = UINavigationController(rootViewController: MyPageVC())
            myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        } else {
            myPageVC = UINavigationController(rootViewController: GuestVC())
            myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        }
        self.setViewControllers([sfMainFeedVC, searchVC, uploadVC, myPageVC], animated: true)
        
    }
}
