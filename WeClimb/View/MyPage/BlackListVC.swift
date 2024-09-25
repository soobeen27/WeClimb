//
//  BlackListVC.swift
//  WeClimb
//
//  Created by 머성이 on 9/26/24.
//

import UIKit

import SnapKit

class BlackListVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        naviUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
    }
    
    private func naviUI() {
        self.title = "차단 목록"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
