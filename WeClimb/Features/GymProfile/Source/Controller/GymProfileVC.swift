//
//  GymProfileVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class GymProfileVC: UIViewController {
    
    var coordinator: GymProfileCoordinator?

    private let gymName: String
    private let level = BehaviorRelay<LHColors?>(value: nil)
    private let hold = BehaviorRelay<LHColors?>(value: nil)
    private let gymProfileVM: GymProfileVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }
    
    private func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    init(viewModel: GymProfileVM, gymName: String, level: LHColors?, hold: LHColors?) {
        self.gymName = gymName
        self.gymProfileVM = viewModel
        self.level.accept(level)
        self.hold.accept(hold)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        
    }
}
