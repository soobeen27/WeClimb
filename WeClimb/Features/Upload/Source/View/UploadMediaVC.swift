//
//  UploadMediaVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit
import RxCocoa
import RxSwift

class UploadMediaVC: UIViewController {
    var coordinator: UploadMediaCoordinator?
    
    let button : RectangleIconButton = {
        let button = RectangleIconButton()
        button.layer.cornerRadius = 10
       return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.yellow
    }
}
