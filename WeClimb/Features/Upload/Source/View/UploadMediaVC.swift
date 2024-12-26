//
//  UploadMediaVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

class UploadMediaVC: UIViewController {
    var coordinator: UploadMediaCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.yellow
    }
}
