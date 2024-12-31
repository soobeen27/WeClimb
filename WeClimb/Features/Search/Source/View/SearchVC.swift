//
//  SearchVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit

class SearchVC: UIViewController {
    var coordinator: SearchCoordinator?
    
    let segmentControl = CustomSegmentedControl(items: ["피드","정보","소식"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.addSubview(segmentControl)
        view.backgroundColor = .white
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        // 선택 변경 시 동작 설정
        segmentControl.onSegmentChanged = { selectedIndex in
            print("선택된 인덱스: \(selectedIndex)")
        }
    }
}
