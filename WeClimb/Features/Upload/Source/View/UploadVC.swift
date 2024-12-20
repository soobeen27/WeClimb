//
//  UploadVC.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

class UploadVC: UIViewController {
    var coordinator: UploadCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.yellow
    }
}
