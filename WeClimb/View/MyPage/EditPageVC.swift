//
//  EditPageVC.swift
//  WeClimb
//
//  Created by 강유정 on 8/29/24.
//

import UIKit

import SnapKit

class EditPageVC: UIViewController {
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.layer.cornerRadius = 20
        return tableView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        setNavigation()
        setLayout()
    }
    
    func setNavigation() {
        self.title = MypageNameSpace.edit
        }
    
    private func setLayout() {
        [profileImage, tableView]
            .forEach { view.addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
    }
    
}
