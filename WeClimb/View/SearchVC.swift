//
//  SearchVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit
import SnapKit

class SearchVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        let Label = UILabel()
        Label.text = "Discover"
        Label.textColor = .black
        Label.font = UIFont.systemFont(ofSize: 17)
        
        let leftBarButtonItem = UIBarButtonItem(customView: Label)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
}
